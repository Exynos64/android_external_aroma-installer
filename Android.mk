LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

## VERSIONING
AROMA_NAME := AROMA Installer
AROMA_VERSION := 3.00b1
AROMA_BUILD := $(shell date +%y%m%d%H)
AROMA_CN := Flamboyan

## TARGET PATH
AROMA_TARGET_PATH := $(PRODUCT_OUT)/aroma

## ZLIB SOURCE FILES
LOCAL_SRC_FILES := \
    libs/zlib/adler32.c \
    libs/zlib/crc32.c \
    libs/zlib/infback.c \
    libs/zlib/inffast.c \
    libs/zlib/inflate.c \
    libs/zlib/inftrees.c \
    libs/zlib/zutil.c

## PNG SOURCE FILES
LOCAL_SRC_FILES += \
    libs/png/png.c \
    libs/png/pngerror.c \
    libs/png/pnggccrd.c \
    libs/png/pngget.c \
    libs/png/pngmem.c \
    libs/png/pngpread.c \
    libs/png/pngread.c \
    libs/png/pngrio.c \
    libs/png/pngrtran.c \
    libs/png/pngrutil.c \
    libs/png/pngset.c \
    libs/png/pngtrans.c \
    libs/png/pngvcrd.c

## MINUTF8 & MINZIP SOURCE FILES
LOCAL_SRC_FILES += \
    libs/minutf8/minutf8.c \
    libs/minzip/DirUtil.c \
    libs/minzip/Hash.c \
    libs/minzip/Inlines.c \
    libs/minzip/SysUtil.c \
    libs/minzip/Zip.c

## FREETYPE SOURCE FILES
LOCAL_SRC_FILES += \
    libs/freetype/autofit/autofit.c \
    libs/freetype/base/basepic.c \
    libs/freetype/base/ftapi.c \
    libs/freetype/base/ftbase.c \
    libs/freetype/base/ftbbox.c \
    libs/freetype/base/ftbitmap.c \
    libs/freetype/base/ftglyph.c \
    libs/freetype/base/ftinit.c \
    libs/freetype/base/ftpic.c \
    libs/freetype/base/ftstroke.c \
    libs/freetype/base/ftsynth.c \
    libs/freetype/base/ftsystem.c \
    libs/freetype/cff/cff.c \
    libs/freetype/pshinter/pshinter.c \
    libs/freetype/psnames/psnames.c \
    libs/freetype/raster/raster.c \
    libs/freetype/sfnt/sfnt.c \
    libs/freetype/smooth/smooth.c \
    libs/freetype/truetype/truetype.c \
    libs/freetype/base/ftlcdfil.c

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
LOCAL_C_INCLUDES := $(LOCAL_PATH)/include
LOCAL_MODULE_PATH := $(AROMA_TARGET_PATH)

## COMPILER FLAGS
LOCAL_CFLAGS := -O2
LOCAL_CFLAGS += -DFT2_BUILD_LIBRARY=1 -DDARWIN_NO_CARBON
LOCAL_CFLAGS += -fdata-sections -ffunction-sections
LOCAL_CFLAGS += -Wl,--gc-sections -fPIC -DPIC
LOCAL_CFLAGS += -D_AROMA_NODEBUG
#LOCAL_CFLAGS += -D_AROMA_VERBOSE_INFO
LOCAL_CFLAGS += -Wno-unused-function -Wno-unused-parameter -Wno-unused-variable -Wno-unused-value
LOCAL_CFLAGS += -Wno-pointer-arith

## SET VERSION
LOCAL_CFLAGS += -DAROMA_NAME="\"$(AROMA_NAME)\""
LOCAL_CFLAGS += -DAROMA_VERSION="\"$(AROMA_VERSION)\""
LOCAL_CFLAGS += -DAROMA_BUILD="\"$(AROMA_BUILD)\""
LOCAL_CFLAGS += -DAROMA_BUILD_CN="\"$(AROMA_CN)\""

## INCLUDED LIBRARIES
LOCAL_STATIC_LIBRARIES := libm libc

ifeq ($(MAKECMDGOALS),$(LOCAL_MODULE))
    $(shell rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES/$(LOCAL_MODULE)_intermediates)
endif

## Remove Old Build
ifeq ($(MAKECMDGOALS),$(LOCAL_MODULE))
    $(shell rm -rf $(PRODUCT_OUT)/obj/EXECUTABLES/$(LOCAL_MODULE)_intermediates)
endif

include $(BUILD_EXECUTABLE)

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
