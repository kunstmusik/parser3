project (parser3)

cmake_minimum_required(VERSION 2.8)

# Flex/Bison for the new parser
find_package(FLEX)
find_package(BISON)

if(NOT FLEX_EXECUTABLE)
    message(FATAL_ERROR "Csound requires the flex executable")
endif()

if(NOT BISON_EXECUTABLE)
    message(FATAL_ERROR "Csound requires the bison executable")
endif()


set(YACC_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/csound_orc.y)
set(YACC_OUT ${CMAKE_CURRENT_BINARY_DIR}/csound_orcparse.c)

set(LEX_SRC ${CMAKE_CURRENT_SOURCE_DIR}/src/csound_orc.l)
set(LEX_OUT ${CMAKE_CURRENT_BINARY_DIR}/csound_orclex.c)

add_custom_command(
    SOURCE ${LEX_SRC}
    COMMAND ${FLEX_EXECUTABLE} ARGS -B -t ${LEX_SRC} > ${LEX_OUT}
    TARGET NewParser
    OUTPUTS ${LEX_OUT})

add_custom_command(
    SOURCE ${YACC_SRC}
    COMMAND ${BISON_EXECUTABLE}
    ARGS -pcsound_orc -d --report=itemset -o ${YACC_OUT} ${YACC_SRC}
    TARGET NewParser
    DEPENDS ${LEX_OUT}
    OUTPUTS ${YACC_OUT})


set_source_files_properties(${YACC_OUT} GENERATED)
set_source_files_properties(${LEX_OUT} GENERATED)
include_directories(${CMAKE_CURRENT_BINARY_DIR})
set(SRCS ${YACC_OUT} ${LEX_OUT} ${CMAKE_CURRENT_SOURCE_DIR}/src/main.c)

set(CMAKE_C_FLAGS "-DYYDEBUG=1")
add_executable(parser3 ${SRCS})

