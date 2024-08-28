LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

LOCAL_SRC_FILES := \
	Hash.c \
	SysUtil.c \
	DirUtil.c \
	Inlines.c \
	Zip.c

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/safe-iop/include \
	external/zlib

LOCAL_STATIC_LIBRARIES := libselinux libsafe_iop

LOCAL_MODULE := libminzip

LOCAL_CLANG := true

LOCAL_CFLAGS += -Werror -Wall

include $(BUILD_STATIC_LIBRARY)

include $(LOCAL_PATH)/safe-iop/Android.mk
