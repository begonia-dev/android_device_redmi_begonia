LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_DEVICE),begonia)

include $(call all-subdir-makefiles,$(LOCAL_PATH))

include $(CLEAR_VARS)

ENGMODE_LIBS := libem_support_jni.so libjni_shim.so
ENGMODE_SYMLINKS := $(addprefix $(TARGET_OUT_APPS_PRIVILEGED)/EngineerMode/lib/arm64/,$(notdir $(ENGMODE_LIBS)))
$(ENGMODE_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	@echo "EngineerMode libs symlinks: $@"
	@mkdir -p $(dir $@)
	@rm -rf $@
	$(hide) ln -sf /system/lib64/$(notdir $@) $@

VENDOR_SYMLINKS := \
    $(TARGET_OUT_VENDOR)/lib/hw \
    $(TARGET_OUT_VENDOR)/lib64/hw

$(VENDOR_SYMLINKS): $(LOCAL_INSTALLED_MODULE)
	$(hide) echo "Making vendor symlinks"
	@mkdir -p $(TARGET_OUT_VENDOR)/lib/hw
	@mkdir -p $(TARGET_OUT_VENDOR)/lib64/hw
	@ln -sf libSoftGatekeeper.so $(TARGET_OUT_VENDOR)/lib/hw/gatekeeper.default.so
	@ln -sf libSoftGatekeeper.so $(TARGET_OUT_VENDOR)/lib64/hw/gatekeeper.default.so
	@ln -sf /vendor/lib/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib/hw/vulkan.mt6785.so
	@ln -sf /vendor/lib64/egl/libGLES_mali.so $(TARGET_OUT_VENDOR)/lib64/hw/vulkan.mt6785.so
	$(hide) touch $@

ALL_DEFAULT_INSTALLED_MODULES += $(ENGMODE_SYMLINKS)
ALL_DEFAULT_INSTALLED_MODULES += $(VENDOR_SYMLINKS)

endif
