set( CMAKE_SYSTEM_NAME Windows )
set( CMAKE_SYSTEM_PROCESSOR arm64 )

set( target arm64-pc-windows-msvc )

set( CMAKE_C_COMPILER    clang )
set( CMAKE_CXX_COMPILER  clang++ )

set( CMAKE_C_COMPILER_TARGET   ${target} )
set( CMAKE_CXX_COMPILER_TARGET ${target} )

set( arch_c_flags "-march=armv8.7-a -Xclang -target-feature -Xclang +fullfp16 -fvectorize -ffp-model=fast -fno-finite-math-only" )
set( warn_c_flags "-Wno-format -Wno-unused-variable -Wno-unused-function -Wno-gnu-zero-variadic-macro-arguments" )

set(CMAKE_MSVC_DEBUG_INFORMATION_FORMAT "")

set(base_flags "${arch_c_flags} ${warn_c_flags}")
# Disable CodeView generation as it causes crashes when cross compiling with
# clang-cl; instead rely solely on DWARF debug information.
set(debug_flags "-g -gdwarf-4 -Xclang -gno-codeview")

set(CMAKE_C_FLAGS_INIT   "${base_flags}")
set(CMAKE_CXX_FLAGS_INIT "${base_flags}")

set(CMAKE_C_FLAGS_DEBUG_INIT            "${debug_flags}")
set(CMAKE_CXX_FLAGS_DEBUG_INIT          "${debug_flags}")
set(CMAKE_C_FLAGS_RELWITHDEBINFO_INIT   "-O2 -DNDEBUG ${debug_flags}")
set(CMAKE_CXX_FLAGS_RELWITHDEBINFO_INIT "-O2 -DNDEBUG ${debug_flags}")
set(CMAKE_C_FLAGS_RELEASE_INIT          "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_RELEASE_INIT        "-O3 -DNDEBUG")
set(CMAKE_C_FLAGS_MINSIZEREL_INIT       "-Os -DNDEBUG")
set(CMAKE_CXX_FLAGS_MINSIZEREL_INIT     "-Os -DNDEBUG")
