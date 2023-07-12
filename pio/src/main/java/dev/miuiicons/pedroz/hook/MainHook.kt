package dev.miuiicons.pedroz.hook

import android.app.Application
import com.github.kyuubiran.ezxhelper.ClassUtils
import com.github.kyuubiran.ezxhelper.EzXHelper
import com.github.kyuubiran.ezxhelper.HookFactory.`-Static`.createHook
import com.github.kyuubiran.ezxhelper.LogExtensions.logexIfThrow
import com.github.kyuubiran.ezxhelper.finders.MethodFinder.`-Static`.methodFinder
import de.robv.android.xposed.IXposedHookLoadPackage
import de.robv.android.xposed.callbacks.XC_LoadPackage

private const val TAG = "MiuiIcons"

@Suppress("unused")
class MainHook : IXposedHookLoadPackage {
    override fun handleLoadPackage(lpparam: XC_LoadPackage.LoadPackageParam) {
        if (lpparam.packageName != "com.miui.home") return

        EzXHelper.initHandleLoadPackage(lpparam)
        EzXHelper.setLogTag(TAG)
        EzXHelper.setToastTag(TAG)

        runCatching {
            hookForPerfectIcons()
        }.logexIfThrow("Hook for perfect icons failed")
    }

    private fun hookForPerfectIcons() {
        runCatching {
            val clazzMiuiSettingsUtils = ClassUtils.loadClass("com.miui.launcher.utils.MiuiSettingsUtils")
            ClassUtils.loadClass("com.miui.home.launcher.Application").methodFinder()
                .filterByName("disablePerfectIcons").first().createHook {
                    before {
                        val contentResolver = (it.thisObject as Application).contentResolver
                        ClassUtils.invokeStaticMethodBestMatch(
                            clazzMiuiSettingsUtils,
                            "putBooleanToSystem",
                            null,
                            contentResolver,
                            "key_miui_mod_icon_enable",
                            true
                        )
                        it.result = null
                    }
                }
        }
        ClassUtils.loadClass("miui.content.res.IconCustomizer").methodFinder()
            .filterByName("isModIconEnabledForPackageName").first().createHook { returnConstant(true) }
    }
}