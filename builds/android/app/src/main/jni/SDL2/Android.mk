LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE := SDL2

EASYRPG_LIB_DIR = $(EASYDEV_ANDROID)/$(TARGET_ARCH_ABI)-toolchain/lib

LOCAL_SRC_FILES := $(EASYRPG_LIB_DIR)/lib$(LOCAL_MODULE).so

include $(PREBUILT_SHARED_LIBRARY)
