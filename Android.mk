LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)

## VERSIONING
AROMA_NAME := AROMA Installer
AROMA_VERSION := 3.00b1
AROMA_BUILD := $(shell date +%y%m%d%H)
AROMA_CN := Flamboyan

## LOCAL AND TARGET PATHS
AROMA_INSTALLER_LOCAL_PATH := $(LOCAL_PATH)
AROMA_INSTALLER_TARGET_PATH := $(PRODUCT_OUT)/aroma

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
LOCAL_MODULE_TAGS := optional
LOCAL_FORCE_STATIC_EXECUTABLE := true

## INCLUDES & OUTPUT PATH
LOCAL_C_INCLUDES := \
    $(AROMA_INSTALLER_LOCAL_PATH)/include \
    $(AROMA_INSTALLER_LOCAL_PATH)/libs \
    external/png \
    external/zlib \
    external/freetype/include
LOCAL_MODULE_PATH := $(AROMA_INSTALLER_TARGET_PATH)

## COMPILER FLAGS
LOCAL_CFLAGS := -O2 
LOCAL_CFLAGS += -DFT2_BUILD_LIBRARY=1 -DDARWIN_NO_CARBON 
LOCAL_CFLAGS += -fdata-sections -ffunction-sections
LOCAL_CFLAGS += -Wl,--gc-sections -fPIC -DPIC
LOCAL_CFLAGS += -D_AROMA_NODEBUG
#LOCAL_CFLAGS += -D_AROMA_VERBOSE_INFO

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
include $(AROMA_INSTALLER_LOCAL_PATH)/libs/freetype/Android.mk

# minzip
include $(AROMA_INSTALLER_LOCAL_PATH)/libs/minzip/Android.mk

include $(CLEAR_VARS)

AROMA_ZIP_TARGET := $(AROMA_INSTALLER_TARGET_PATH)/aroma.zip
$(AROMA_ZIP_TARGET):
	@echo "----- Making aroma zip installer ------"
	$(hide) rm -rf $(AROMA_INSTALLER_TARGET_PATH)/assets \
	               $(AROMA_INSTALLER_TARGET_PATH)/aroma.zip
	$(hide) cp -R $(AROMA_INSTALLER_LOCAL_PATH)/assets \
	              $(AROMA_INSTALLER_TARGET_PATH)/assets
	$(hide) cp $(AROMA_INSTALLER_TARGET_PATH)/aroma_installer \
	           $(AROMA_INSTALLER_TARGET_PATH)/assets/META-INF/com/google/android/update-binary
	$(hide) pushd $(AROMA_INSTALLER_TARGET_PATH)/assets && \
	        zip -r9 ../aroma.zip . && \
	        popd
	@echo "Made flashable aroma.zip: $@"

.PHONY: aroma_installer_zip
aroma_installer_zip: $(AROMA_ZIP_TARGET)
