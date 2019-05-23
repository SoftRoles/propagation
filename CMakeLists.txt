cmake_minimum_required(VERSION 3.2)
project(propagation CXX)
set(CMAKE_CXX_STANDARD 11)
#set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} --std=c++11")

include_directories(include)

add_library(pathloss STATIC src/pathloss.cpp)
#file(GLOB SOURCES "src/*.cpp")

#foreach(source ${SOURCES})
 #   get_filename_component(fname, "/root", NAME)
  #  message("Filename: ${fname} ")
   # message("Filename: ${source} ")
    #add_library(... STATIC ${source})
#endforeach()

