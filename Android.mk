LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

## VERSIONING
AROMA_NAME := AROMA Installer
AROMA_VERSION := 3.00b1
AROMA_BUILD := $(shell date +%y%m%d%H)
AROMA_CN := Flamboyan

## TARGET PATH
AROMA_TARGET_PATH := $(PRODUCT_OUT)/aroma

## MINUTF8 SOURCE FILE
LOCAL_SRC_FILES += \
    libs/minutf8/minutf8.c

## EDIFY PARSER SOURCE FILES
LOCAL_SRC_FILES += \
    src/edify/expr.c \
    src/edify/lex.yy.c \
    src/edify/parser.c

## AROMA CONTROLS SOURCE FILES
LOCAL_SRC_FILES += \
    src/controls/aroma_controls.c \
    src/controls/aroma_control_button.c \
    src/controls/aroma_control_check.c \
    src/controls/aroma_control_checkbox.c \
    src/controls/aroma_control_menubox.c \
    src/controls/aroma_control_checkopt.c \
    src/controls/aroma_control_optbox.c \
    src/controls/aroma_control_textbox.c \
    src/controls/aroma_control_threads.c \
    src/controls/aroma_control_imgbutton.c

## AROMA LIBRARIES SOURCE FILES
LOCAL_SRC_FILES += \
    src/libs/aroma_array.c \
    src/libs/aroma_freetype.c \
    src/libs/aroma_graph.c \
    src/libs/aroma_input.c \
    src/libs/aroma_languages.c \
    src/libs/aroma_libs.c \
    src/libs/aroma_memory.c \
    src/libs/aroma_png.c \
    src/libs/aroma_zip.c

## AROMA INSTALLER SOURCE FILES
LOCAL_SRC_FILES += \
    src/main/aroma_ui.c \
    src/main/aroma_installer.c \
    src/main/aroma.c

## MODULE SETTINGS
LOCAL_MODULE_TARGET_ARCH := arm
LOCAL_MODULE := aroma_installer
LOCAL_FORCE_STATIC_EXECUTABLE := true

## INCLUDES & OUTPUT PATH
LOCAL_C_INCLUDES := \
    $(LOCAL_PATH)/include \
    external/png \
    external/zlib \
    external/freetype/include \
    bootable/recovery
LOCAL_MODULE_PATH := $(AROMA_TARGET_PATH)

## COMPILER FLAGS
LOCAL_CFLAGS := -O2
LOCAL_CFLAGS += -DFT2_BUILD_LIBRARY=1 -DDARWIN_NO_CARBON
LOCAL_CFLAGS += -fdata-sections -ffunction-sections
LOCAL_CFLAGS += -Wl,--gc-sections -fPIC -DPIC
LOCAL_CFLAGS += -D_AROMA_NODEBUG
#LOCAL_CFLAGS += -D_AROMA_VERBOSE_INFO
LOCAL_CFLAGS += -Wno-unused-function -Wno-unused-parameter -Wno-unused-variable -Wno-unused-value

## SET VERSION
LOCAL_CFLAGS += -DAROMA_NAME="\"$(AROMA_NAME)\""
LOCAL_CFLAGS += -DAROMA_VERSION="\"$(AROMA_VERSION)\""
LOCAL_CFLAGS += -DAROMA_BUILD="\"$(AROMA_BUILD)\""
LOCAL_CFLAGS += -DAROMA_BUILD_CN="\"$(AROMA_CN)\""

## INCLUDED LIBRARIES
LOCAL_STATIC_LIBRARIES := libminzip libpng libc libz libft2_aroma_static libm

ifeq ($(MAKECMDGOALS),$(LOCAL_MODULE))
    $(shell rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES/$(LOCAL_MODULE)_intermediates)
endif

## Remove Old Build
ifeq ($(MAKECMDGOALS),$(LOCAL_MODULE))
    $(shell rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES/$(LOCAL_MODULE)_intermediates)
endif

include $(BUILD_EXECUTABLE)

# freetype
include $(LOCAL_PATH)/libs/freetype/Android.mk

include $(CLEAR_VARS)

AROMA_ZIP_TARGET := $(AROMA_TARGET_PATH)/aroma.zip
$(AROMA_ZIP_TARGET):
	@echo "----- Making aroma zip installer ------"
	$(hide) rm -rf $(AROMA_TARGET_PATH)/out/aroma.zip
	$(hide) rm -rf $(AROMA_TARGET_PATH)/assets/META-INF/com/google/android/update-binary
	$(hide) cp $(AROMA_TARGET_PATH)/out/aroma_installer $(AROMA_TARGET_PATH)/assets/META-INF/com/google/android/update-binary
	$(hide) cd $(AROMA_TARGET_PATH)/assets && zip -r9 ../out/aroma.zip .
	$(hide) rm -rf $(AROMA_TARGET_PATH)/assets/META-INF/com/google/android/update-binary
	@echo "Made flashable aroma.zip: $@"

.PHONY: aroma_installer_zip

aroma_installer_zip: $(AROMA_ZIP_TARGET)
