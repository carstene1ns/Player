
# setup helper variables
set(DKPRO "$ENV{DEVKITPRO}")
set(DKPPC "$ENV{DEVKITPPC}")

# check environment
if(DKPRO STREQUAL "" OR DKPPC STREQUAL "")
  message(FATAL_ERROR "You need to setup DevkitPPC properly by exporting the required "
    "environment variables DEVKITPRO and DEVKITPPC! ")
endif()

set(CMAKE_SYSTEM_NAME Generic)

set(CMAKE_CXX_COMPILER ${DKPPC}/bin/powerpc-eabi-g++)

# help FindXXX.cmake modules
set(CMAKE_FIND_ROOT_PATH ${DKPRO}/portlibs/ppc)
# this finds sdl, but not sdl_mixer:
#set(CMAKE_FIND_ROOT_PATH ${DKPRO}/portlibs/ppc ${DKPRO}/libogc)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
# this seems to have no effect at all:
#set(CMAKE_INCLUDE_PATH ${CMAKE_INCLUDE_PATH} ${DKPRO}/libogc/include ${DKPRO}/portlibs/ppc/include)
#set(CMAKE_LIBRARY_PATH ${CMAKE_LIBRARY_PATH} ${DKPRO}/libogc/lib/wii ${DKPRO}/portlibs/ppc/lib)

# help pkg-config
set($ENV{PKG_CONFIG_LIBDIR} $DEVKITPRO/portlibs/ppc/lib/pkgconfig)

# disable ICU, use iconv
set(DISABLE_ICU true)

# disable wine
set(DISABLE_WINE true)

# disable tests
set(DISABLE_TESTS true)

# sdl and sdl_mixer can not be found otherwise
set(SDL_INCLUDE_DIR ${DKPRO}/libogc/include/SDL)
set(SDL_LIBRARY ${DKPRO}/libogc/lib/wii/libSDL.a)
set(SDL_MIXER_INCLUDE_DIR ${DKPRO}/libogc/include/SDL)
set(SDL_MIXER_LIBRARY ${DKPRO}/libogc/lib/wii/libSDL_mixer.a)

# this is a quirk, because cmake's FindFreetype module is broken
set(ENV{FREETYPE_DIR} ${DKPRO}/portlibs/ppc)

# additional flags
set(WII_COMMON_FLAGS "-mrvl -mcpu=750 -meabi -mhard-float")
set(EASYRPG_TOOLCHAIN_CXX_FLAGS "${WII_COMMON_FLAGS} -fno-exceptions")
set(EASYRPG_TOOLCHAIN_LINKER_FLAGS
  "${WII_COMMON_FLAGS} -Wl,-Map,${CMAKE_CURRENT_SOURCE_DIR}/builds/wii/easyrpg-player-wii.map")

# additional defines
add_definitions(-DWORDS_BIGENDIAN=1 -DGEKKO)

# additional include directories
include_directories("${DKPRO}/libogc/include")

# additional libraries
set(EASYRPG_TOOLCHAIN_LIBRARIES
    ${DKPRO}/libogc/lib/wii/libmad.a
	${DKPRO}/portlibs/ppc/lib/libvorbisidec.a
	${DKPRO}/libogc/lib/wii/libfat.a
	${DKPRO}/libogc/lib/wii/libwiikeyboard.a
	${DKPRO}/libogc/lib/wii/libwiiuse.a
	${DKPRO}/libogc/lib/wii/libbte.a
	${DKPRO}/libogc/lib/wii/libogc.a
)
