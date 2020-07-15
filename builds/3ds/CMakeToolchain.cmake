
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/devkit-helper.cmake)

set(CMAKE_SYSTEM_PROCESSOR "armv6k")
set(N3DS TRUE)
set(CTRULIB ${DEVKITPRO}/libctru)

set(arch_flags "-march=armv6k -mtune=mpcore -mfloat-abi=hard -mtp=soft -ffunction-sections -fdata-sections")
set(inc_flags "-I${CTRULIB}/include ${arch_flags} -mword-relocations")
set(link_flags "-L${CTRULIB}/lib -lctru -specs=3dsx.specs ${arch_flags} -Wl,--gc-sections")

# this pulls in the generic tools and sets above flags
devkit("ARM")

add_definitions(-D_3DS -DARM11 -Wno-psabi)

find_program(3DSLINK 3dslink)
find_program(3DSXTOOL 3dsxtool)
find_program(SMDHTOOL smdhtool)

# defaults
set(PLAYER_TARGET_PLATFORM "3ds" CACHE STRING "target platform")
set(PLAYER_AUDIO_BACKEND "3ds" CACHE STRING "audio backend")

# the additional commands and targets should only be included once
if(DEFINED HAVE_3DS_TOOLCHAIN)
  return()
else()
  set(HAVE_3DS_TOOLCHAIN 1)
endif()

set(BINARY_NAME "easyrpg-player")
set(3DS_APPNAME "EasyRPG Player")
set(3DS_SUMMARY "Play your RPG Maker 2000/2003 games everywhere")
set(3DS_AUTHORS "EasyRPG Team & Rinnegatamante")

add_custom_command(OUTPUT ${BINARY_NAME}.smdh
	COMMAND ${SMDHTOOL} --create ${3DS_APPNAME} ${3DS_SUMMARY} ${3DS_AUTHORS} ${CMAKE_SOURCE_DIR}/builds/3ds/icon.png ${BINARY_NAME}.smdh
	DEPENDS ${CMAKE_SOURCE_DIR}/builds/3ds/icon.png
	VERBATIM)

add_custom_command(OUTPUT ${BINARY_NAME}.3dsx
	COMMAND ${3DSXTOOL} ${BINARY_NAME}.elf ${BINARY_NAME}.3dsx --smdh=${BINARY_NAME}.smdh
	DEPENDS ${BINARY_NAME}.elf ${BINARY_NAME}.smdh
	VERBATIM)

add_custom_target(run ${3DSLINK} ${CMAKE_CURRENT_BINARY_DIR}/${BINARY_NAME}.3dsx
	DEPENDS ${BINARY_NAME}.3dsx)
