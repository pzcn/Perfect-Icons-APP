package com.projectkr.shell.permissions

import android.Manifest
import android.annotation.SuppressLint
import android.content.Context
import android.os.Build
import android.os.Handler
import android.os.Looper
import androidx.core.content.PermissionChecker
import com.omarea.common.shell.KeepShellPublic
import com.omarea.common.ui.DialogHelper
import com.projectkr.shell.R
import kotlin.system.exitProcess

/**
 * 检查获取root权限
 * Created by helloklf on 2017/6/3.
 */

public class CheckRootStatus(var context: Context, private var next: Runnable? = null) {
    private var myHandler: Handler = Handler(Looper.getMainLooper())

    var thread: Thread? = null
    @SuppressLint("SuspiciousIndentation")
    fun forceGetRoot() {
        if (lastCheckResult) {
            if (next != null) {
                myHandler.post(next!!)
            }
        } else {
            var completed = false
            thread = Thread {
                rootStatus = KeepShellPublic.checkRoot()
                if (completed) {
                    return@Thread
                }

                completed = true

                    if (next != null) {
                        myHandler.post(next!!)
                }
            }
            thread!!.start()
            Thread {
                Thread.sleep(1000 * 15)

                if (!completed) {
                    KeepShellPublic.tryExit()
                    myHandler.post {
                        DialogHelper.confirm(context,
                            context.getString(R.string.error_root),
                            context.getString(R.string.error_su_timeout),
                            null,
                            DialogHelper.DialogButton(context.getString(R.string.btn_retry), {
                                if (thread != null && thread!!.isAlive && !thread!!.isInterrupted) {
                                    thread!!.interrupt()
                                    thread = null
                                }
                                forceGetRoot()
                            }),
                            DialogHelper.DialogButton(context.getString(R.string.btn_exit), {
                                exitProcess(0)
                            })
                        )
                    }
                }
            }.start()
        }
    }

    companion object {
        private var rootStatus = false
        private fun checkPermission(context: Context, permission: String): Boolean = PermissionChecker.checkSelfPermission(context, permission) == PermissionChecker.PERMISSION_GRANTED
        fun grantPermission(context: Context) {
            val cmds = StringBuilder()
            /*
            // 必需的权限
            val requiredPermission = arrayOf(
                    Manifest.permission.READ_EXTERNAL_STORAGE,
                    Manifest.permission.WRITE_EXTERNAL_STORAGE
            )
            requiredPermission.forEach {
                if (!checkPermission(context, it)) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        val option = it.substring("android.permission.".length)
                        cmds.append("appops set ${context.packageName} ${option} allow\n")
                    }
                    cmds.append("pm grant ${context.packageName} $it\n")
                }
            }
            */

            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (!checkPermission(context, Manifest.permission.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS)) {
                    cmds.append("dumpsys deviceidle whitelist +${context.packageName};\n")
                }
            }
            KeepShellPublic.doCmdSync(cmds.toString())
        }

        // 最后的ROOT检测结果
        val lastCheckResult: Boolean
            get() {
                return rootStatus
            }
    }
}
