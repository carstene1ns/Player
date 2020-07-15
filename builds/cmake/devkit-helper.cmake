
if(DEFINED ENV{DEVKITPRO})
	set(DEVKITPRO $ENV{DEVKITPRO})
else()
	message(FATAL_ERROR "Could not find DEVKITPRO in environment")
endif()

set(CMAKE_SYSTEM_NAME Generic)

cmake_minimum_required(VERSION 3.16)
set(CMAKE_FIND_USE_CMAKE_SYSTEM_PATH FALSE)

set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE BOTH)

set(BUILD_SHARED_LIBS OFF CACHE INTERNAL "Shared libs not available")

function(devkit DEVKIT)
	set(DEVKIT${DEVKIT} ${DEVKITPRO}/devkit${DEVKIT})
	set(DEVKIT${DEVKIT} "${DEVKIT${DEVKIT}}" PARENT_SCOPE)

	if(${DEVKIT} STREQUAL "ARM")
		set(abi "arm-none-eabi")
		set(portlibs "${DEVKITPRO}/portlibs/3ds")
	elseif(${DEVKIT} STREQUAL "A64")
		set(abi "aarch64-none-elf")
		set(portlibs "${DEVKITPRO}/portlibs/switch")
	elseif(${DEVKIT} STREQUAL "PPC")
		set(abi "powerpc-eabi")
		set(portlibs "${DEVKITPRO}/portlibs/wii;${DEVKITPRO}/portlibs/ppc")
	else()
		message(FATAL_ERROR "Invalid devkit!")
	endif()
	set(CMAKE_LIBRARY_ARCHITECTURE ${abi} CACHE INTERNAL "abi")

	set(CMAKE_PROGRAM_PATH "${DEVKIT${DEVKIT}}/bin;${DEVKITPRO}/tools/bin" PARENT_SCOPE)

	set(TOOL_PREFIX ${DEVKIT${DEVKIT}}/bin/${abi}-)

	set(CMAKE_ASM_COMPILER ${TOOL_PREFIX}gcc CACHE PATH "assembler")
	set(CMAKE_C_COMPILER ${TOOL_PREFIX}gcc CACHE PATH "c compiler")
	set(CMAKE_CXX_COMPILER ${TOOL_PREFIX}g++ CACHE PATH "cxx compiler")
	set(CMAKE_LINKER ${TOOL_PREFIX}ld CACHE PATH "linker")
	#set(CMAKE_AR ${TOOL_PREFIX}gcc-ar CACHE PATH "archiver")
	#set(CMAKE_RANLIB ${TOOL_PREFIX}gcc-ranlib CACHE PATH "archiver")
	set(CMAKE_STRIP ${TOOL_PREFIX}strip CACHE PATH "symbol remover")

	set(CMAKE_C_FLAGS ${inc_flags} CACHE INTERNAL "c compiler flags")
	set(CMAKE_ASM_FLAGS ${inc_flags} CACHE INTERNAL "assembler flags")
	set(CMAKE_CXX_FLAGS ${inc_flags} CACHE INTERNAL "cxx compiler flags")

	set(CMAKE_EXE_LINKER_FLAGS ${link_flags} CACHE INTERNAL "exe link flags")
	set(CMAKE_MODULE_LINKER_FLAGS ${link_flags} CACHE INTERNAL "module link flags")
	set(CMAKE_SHARED_LINKER_FLAGS ${link_flags} CACHE INTERNAL "shared link flags")

	set(CMAKE_FIND_ROOT_PATH "${DEVKIT${DEVKIT}}/${CMAKE_LIBRARY_ARCHITECTURE};${portlibs}" PARENT_SCOPE)
endfunction()
