package com.omarea.krscript.ui

import android.app.Dialog
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.DialogInterface
import android.os.Build
import android.os.Bundle
import android.os.Message
import android.text.SpannableString
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.ProgressBar
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast
import androidx.fragment.app.DialogFragment
import com.omarea.common.ui.DialogHelper
import com.omarea.krscript.R
import com.omarea.krscript.databinding.KrDialogLogBinding
import com.omarea.krscript.executor.ShellExecutor
import com.omarea.krscript.model.RunnableNode
import com.omarea.krscript.model.ShellHandlerBase


@Suppress("DEPRECATION")
class DialogLogFragment : DialogFragment() {
    override fun onCreateView(inflater: LayoutInflater, container: ViewGroup?, savedInstanceState: Bundle?): View {
        // val view = inflater.inflate(R.layout.kr_dialog_log, container, false)

        _binding = KrDialogLogBinding.inflate(inflater, container, false)
        return binding.root
    }

    private var running = false
    private var nodeInfo: RunnableNode? = null
    private lateinit var onExit: Runnable
    private lateinit var script: String
    private var params: HashMap<String, String>? = null
    private var themeResId: Int = 0
    private var _binding: KrDialogLogBinding? = null
    private val binding get() = _binding!!

    override fun onCreateDialog(savedInstanceState: Bundle?): Dialog {
        return Dialog(requireActivity(), if (themeResId != 0) themeResId else R.style.kr_full_screen_dialog_light)
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val activity = this.activity
        if (activity != null) {
            dialog?.window?.run {
                DialogHelper.setWindowBlurBg(this, activity)
            }
        }
    }

    @Deprecated("Deprecated in Java")
    override fun onActivityCreated(savedInstanceState: Bundle?) {
        super.onActivityCreated(savedInstanceState)
        if (nodeInfo != null) {
            nodeInfo?.run {
                // 如果执行完以后需要刷新界面，那么就不允许隐藏日志窗口到后台执行
                if (reloadPage) {
                    binding.btnHide.visibility = View.GONE
                }

                val shellHandler = openExecutor(this)

                ShellExecutor().execute(activity, this, script, onExit, params, shellHandler)
            }
        } else {
            dismiss()
        }
    }

    private fun openExecutor(nodeInfo: RunnableNode): ShellHandlerBase {
        var forceStopRunnable: Runnable? = null

        binding.btnHide.setOnClickListener {
            closeView()
        }
        binding.btnExit.setOnClickListener {
            if (running) {
                forceStopRunnable?.run()
            }
            closeView()
        }

        binding.btnCopy.setOnClickListener {
            try {
                val myClipboard: ClipboardManager = this.requireContext().getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                val myClip: ClipData = ClipData.newPlainText("text", binding.shellOutput.text.toString())
                myClipboard.setPrimaryClip(myClip)
                Toast.makeText(context, getString(R.string.copy_success), Toast.LENGTH_SHORT).show()
            } catch (ex: Exception) {
                Toast.makeText(context, getString(R.string.copy_fail), Toast.LENGTH_SHORT).show()
            }
        }
        if (nodeInfo.interruptable) {
            binding.btnHide.visibility = View.VISIBLE
            binding.btnExit.visibility = View.VISIBLE
        } else {
            binding.btnHide.visibility = View.GONE
            binding.btnExit.visibility = View.GONE
        }

        if (nodeInfo.title.isNotEmpty()) {
            binding.title.text = nodeInfo.title
        } else {
            binding.title.visibility = View.GONE
        }

        if (nodeInfo.desc.isNotEmpty()) {
            binding.desc.text = nodeInfo.desc
        } else {
            binding.desc.visibility = View.GONE
        }

        binding.actionProgress.isIndeterminate = true
        return MyShellHandler(object : IActionEventHandler {
            override fun onCompleted() {
                running = false

                onExit.run()

                binding.btnHide.visibility = View.GONE
                binding.btnExit.visibility = View.VISIBLE
                binding.actionProgress.visibility = View.GONE

                isCancelable = true
            }

            override fun onSuccess() {
                if (nodeInfo.autoOff) {
                    closeView()
                }
            }

            override fun onStart(forceStop: Runnable?) {
                running = true

                if (nodeInfo.interruptable && forceStop != null) {
                    binding.btnExit.visibility = View.VISIBLE
                } else {
                    binding.btnExit.visibility = View.GONE
                }
                forceStopRunnable = forceStop
            }

        }, binding.shellOutput, binding.actionProgress)
    }

    @FunctionalInterface
    interface IActionEventHandler {
        fun onStart(forceStop: Runnable?)
        fun onSuccess()
        fun onCompleted()
    }

    class MyShellHandler(
            private var actionEventHandler: IActionEventHandler,
            private var logView: TextView,
            private var shellProgress: ProgressBar) : ShellHandlerBase() {

        private fun getColor(resId: Int): Int {
            return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                context!!.getColor(resId)
            } else {
                context!!.resources.getColor(resId)
            }
        }

        private val context = logView.context
        private val errorColor = getColor(R.color.kr_shell_log_error)
        private val basicColor = getColor(R.color.kr_shell_log_basic)
        private val scriptColor = getColor(R.color.kr_shell_log_script)
        private val endColor = getColor(R.color.kr_shell_log_end)

        private var hasError = false // 执行过程是否出现错误

        override fun handleMessage(msg: Message) {
            when (msg.what) {
                EVENT_EXIT -> onExit(msg.obj)
                EVENT_START -> {
                    onStart(msg.obj)
                }
                EVENT_REDE -> onReaderMsg(msg.obj)
                EVENT_READ_ERROR -> onError(msg.obj)
                EVENT_WRITE -> {
                    onWrite(msg.obj)
                }
            }
        }

        override fun onReader(msg: Any) {
            updateLog(msg, basicColor)
        }

        override fun onWrite(msg: Any) {
            updateLog(msg, scriptColor)
        }

        override fun onError(msg: Any) {
            hasError = true
            updateLog(msg, errorColor)
        }

        override fun onStart(forceStop: Runnable?) {
            actionEventHandler.onStart(forceStop)
        }

        override fun onProgress(current: Int, total: Int) {
            when (current) {
                -1 -> {
                    this.shellProgress.visibility = View.VISIBLE
                    this.shellProgress.isIndeterminate = true
                }
                total -> this.shellProgress.visibility = View.GONE
                else -> {
                    this.shellProgress.visibility = View.VISIBLE
                    this.shellProgress.isIndeterminate = false
                    this.shellProgress.max = total
                    this.shellProgress.progress = current
                }
            }
        }

        override fun onStart(msg: Any?) {
            this.logView.text = ""
            // updateLog(msg, scriptColor)
        }

        override fun onExit(msg: Any?) {
            updateLog(context.getString(R.string.kr_shell_completed), endColor)
            actionEventHandler.onCompleted()
            if (!hasError) {
                actionEventHandler.onSuccess()
            }
        }

        override fun updateLog(msg: SpannableString?) {
            if (msg != null) {
                this.logView.post {
                    logView.append(msg)
                    (logView.parent as ScrollView).fullScroll(ScrollView.FOCUS_DOWN)
                }
            }
        }
    }

    private fun closeView() {
        try {
            dismiss()
        } catch (_: Exception) {
        }
    }

    private var onDismissRunnable: Runnable? = null
    override fun onDismiss(dialog: DialogInterface) {
        super.onDismiss(dialog)
        onDismissRunnable?.run()
        onDismissRunnable = null
    }

    companion object {
        fun create(nodeInfo: RunnableNode,
                   onExit: Runnable,
                   onDismiss: Runnable,
                   script: String,
                   params: HashMap<String, String>?,
                   darkMode: Boolean = false): DialogLogFragment {
            return DialogLogFragment().apply {
                this.nodeInfo = nodeInfo
                this.onExit = onExit
                this.script = script
                this.params = params
                this.themeResId = if (darkMode) R.style.kr_full_screen_dialog_dark else R.style.kr_full_screen_dialog_light
                this.onDismissRunnable = onDismiss
            }
        }
    }
}
