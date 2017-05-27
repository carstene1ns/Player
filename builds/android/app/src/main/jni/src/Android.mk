LOCAL_PATH := $(call my-dir)

EASYRPG_TOOLCHAIN_DIR = $(EASYDEV_ANDROID)/$(TARGET_ARCH_ABI)-toolchain

include $(CLEAR_VARS)

LOCAL_MODULE := main

PLAYER_PATH := ../../../../../../../

LOCAL_C_INCLUDES := \
	$(LOCAL_PATH)/$(PLAYER_PATH)/src \
	$(EASYRPG_TOOLCHAIN_DIR)/include/SDL2

# Add your application source files here...
LOCAL_SRC_FILES := SDL_android_main.c \
	org_easyrpg_player_player_EasyRpgPlayerActivity.cpp \
	$(patsubst $(LOCAL_PATH)/%, %, $(wildcard $(LOCAL_PATH)/$(PLAYER_PATH)/src/*.cpp))

LOCAL_SHARED_LIBRARIES := SDL2

LOCAL_STATIC_LIBRARIES := \
		SDL2_mixer vorbisfile vorbis ogg \
		xmp-lite mpg123 speexdsp sndfile \
		freetype pixman-1 png \
		lcf expat icui18n icuuc icudata \
		cpufeatures

LOCAL_LDLIBS := -lGLESv1_CM -llog -lz

LOCAL_CFLAGS := -O2 -Wall -Wextra -DUSE_SDL \
		-DHAVE_SDL_MIXER -DHAVE_MPG123 -DWANT_FMMIDI=2 \
		-DHAVE_OGGVORBIS -DHAVE_XMP -DHAVE_LIBSNDFILE \
		-DHAVE_LIBSPEEXDSP -DSUPPORT_AUDIO

LOCAL_CXXFLAGS := $(LOCAL_C_FLAGS) -std=c++11 -fno-rtti

include $(BUILD_SHARED_LIBRARY)

$(call import-module,android/cpufeatures)
