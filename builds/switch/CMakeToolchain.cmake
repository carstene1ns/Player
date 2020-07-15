
include(${CMAKE_CURRENT_LIST_DIR}/../cmake/devkit-helper.cmake)

set(CMAKE_SYSTEM_PROCESSOR "aarch64")
set(NSWITCH TRUE)
set(NX_ROOT ${DEVKITPRO}/libnx)

set(arch_flags "-march=armv8-a+crc+crypto -mtune=cortex-a57 -mtp=soft -fPIE -ffunction-sections")
set(inc_flags "-I${NX_ROOT}/include ${arch_flags}")
set(link_flags "-L${NX_ROOT}/lib -lnx -specs=${NX_ROOT}/switch.specs ${arch_flags} -Wl,--gc-sections")

# this pulls in the generic tools and sets above flags
devkit("A64")

#set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_definitions(-D__SWITCH__)

find_program(NXLINK nxlink)
find_program(ELF2NRO elf2nro)
find_program(NACPTOOL nacptool)

# defaults
set(PLAYER_TARGET_PLATFORM "switch" CACHE STRING "target platform")
set(PLAYER_AUDIO_BACKEND "switch" CACHE STRING "audio backend")
set(PLAYER_AUDIO_RESAMPLER "samplerate" CACHE STRING "audio resampler")

# the additional commands and targets should only be included once
if(DEFINED HAVE_NX_TOOLCHAIN)
  return()
else()
  set(HAVE_NX_TOOLCHAIN 1)
endif()

set(BINARY_NAME "easyrpg-player")
set(NX_APPNAME "EasyRPG Player")
set(NX_AUTHORS "EasyRPG Team & Rinnegatamante")
set(NX_VERSION ${PROJECT_VERSION})

add_custom_command(OUTPUT ${BINARY_NAME}.nacp
	COMMAND ${NACPTOOL} --create ${NX_APPNAME} ${NX_AUTHORS} ${NX_VERSION} ${BINARY_NAME}.nacp
	VERBATIM)

add_custom_command(OUTPUT ${BINARY_NAME}.nro
	COMMAND ${ELF2NRO} ${BINARY_NAME}.elf ${BINARY_NAME}.nro --icon=${CMAKE_SOURCE_DIR}/builds/switch/icon.jpg --nacp=${BINARY_NAME}.nacp
	DEPENDS ${BINARY_NAME}.elf ${BINARY_NAME}.nacp ${CMAKE_SOURCE_DIR}/builds/switch/icon.jpg
	VERBATIM)

add_custom_target(run ${NXLINK} ${CMAKE_CURRENT_BINARY_DIR}/${BINARY_NAME}.nro
	DEPENDS ${BINARY_NAME}.nro)
