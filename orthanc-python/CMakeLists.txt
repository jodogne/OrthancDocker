cmake_minimum_required(VERSION 2.8)
project(OrthancPython)

set(PLUGIN_VERSION "4.1")

if (PLUGIN_VERSION STREQUAL "mainline")
  set(ORTHANC_FRAMEWORK_DEFAULT_VERSION "mainline")
  set(ORTHANC_FRAMEWORK_DEFAULT_SOURCE "hg")
else()
  set(ORTHANC_FRAMEWORK_DEFAULT_VERSION "1.12.1")
  set(ORTHANC_FRAMEWORK_DEFAULT_SOURCE "web")
endif()


if (NOT ${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  # The Python version cannot be controlled on OS X (yet)
  set(PYTHON_VERSION "3.10" CACHE STRING "Version of Python to be used")
endif()

if (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
  # Windows-specific options
  set(PYTHON_WINDOWS_ROOT "" CACHE STRING "")
  set(PYTHON_LIBRARY_NAME "" CACHE STRING "")
  set(PYTHON_WINDOWS_USE_RELEASE_LIBS ON CACHE BOOL "Use the release Python libraries when building with Microsoft Visual Studio, even when compiling in _DEBUG mode (set it to OFF if you require linking to a Python debug build)")
endif()



# Parameters of the build
set(STATIC_BUILD OFF CACHE BOOL "Static build of the third-party libraries (necessary for Windows)")
set(ALLOW_DOWNLOADS OFF CACHE BOOL "Allow CMake to download packages")
set(ORTHANC_FRAMEWORK_SOURCE "${ORTHANC_FRAMEWORK_DEFAULT_SOURCE}" CACHE STRING "Source of the Orthanc framework (can be \"system\", \"hg\", \"archive\", \"web\" or \"path\")")
set(ORTHANC_FRAMEWORK_VERSION "${ORTHANC_FRAMEWORK_DEFAULT_VERSION}" CACHE STRING "Version of the Orthanc framework")
set(ORTHANC_FRAMEWORK_ARCHIVE "" CACHE STRING "Path to the Orthanc archive, if ORTHANC_FRAMEWORK_SOURCE is \"archive\"")
set(ORTHANC_FRAMEWORK_ROOT "" CACHE STRING "Path to the Orthanc source directory, if ORTHANC_FRAMEWORK_SOURCE is \"path\"")
set(USE_FRAMEWORK_ORTHANC_SDK OFF CACHE BOOL "Whether to use the SDK from the Orthanc sources (for developers only, to support new features of the SDK that are still pending in the mainline)")

# Advanced parameters to fine-tune linking against system libraries
set(ORTHANC_FRAMEWORK_STATIC OFF CACHE BOOL "If linking against the Orthanc framework system library, indicates whether this library was statically linked")
mark_as_advanced(ORTHANC_FRAMEWORK_STATIC)


# Download and setup the Orthanc framework
include(${CMAKE_SOURCE_DIR}/Resources/Orthanc/CMake/DownloadOrthancFramework.cmake)

if (ORTHANC_FRAMEWORK_SOURCE STREQUAL "system")
  include(FindBoost)
  find_package(Boost COMPONENTS filesystem regex thread)

  if (NOT Boost_FOUND)
    message(FATAL_ERROR "Unable to locate Boost on this system")
  endif()

  link_libraries(${Boost_LIBRARIES} jsoncpp)

else()
  include(${ORTHANC_FRAMEWORK_ROOT}/../Resources/CMake/OrthancFrameworkParameters.cmake)
  
  #set(ENABLE_MODULE_IMAGES OFF CACHE INTERNAL "")
  #set(ENABLE_MODULE_JOBS OFF CACHE INTERNAL "")
  #set(ENABLE_MODULE_DICOM OFF CACHE INTERNAL "")
  
  include(${ORTHANC_FRAMEWORK_ROOT}/../Resources/CMake/OrthancFrameworkConfiguration.cmake)
  include_directories(${ORTHANC_FRAMEWORK_ROOT})
endif()


include(${CMAKE_SOURCE_DIR}/Resources/Orthanc/Plugins/OrthancPluginsExports.cmake)


include(CheckIncludeFile)
include(CheckIncludeFileCXX)
include(CheckIncludeFiles)
include(CheckLibraryExists)
include(FindPythonInterp)


if (${CMAKE_SYSTEM_NAME} STREQUAL "Darwin")
  find_package(PythonLibs)
  if (NOT PYTHONLIBS_FOUND)
    message(FATAL_ERROR "Cannot find the Python libraries")
  endif()

  message("Python library - Found version: ${PYTHONLIBS_VERSION_STRING}")
  message("Python library - Path to include directory: ${PYTHON_INCLUDE_DIRS}")
  message("Python library - Shared library: ${PYTHON_LIBRARIES}")

else()
  string(REGEX REPLACE "^([0-9]*)\\.([0-9]*)$" "\\1" PYTHON_VERSION_MAJOR ${PYTHON_VERSION})
  string(REGEX REPLACE "^([0-9]*)\\.([0-9]*)$" "\\2" PYTHON_VERSION_MINOR ${PYTHON_VERSION})

  if (NOT PYTHON_VERSION STREQUAL
      "${PYTHON_VERSION_MAJOR}.${PYTHON_VERSION_MINOR}")
    message(FATAL_ERROR "Error in the (x.y) format of the Python version: ${PYTHON_VERSION}")
  endif()

  if (${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
    if ("${PYTHON_LIBRARY_NAME}" STREQUAL "")
      if (MSVC)
        set(Prefix "")
        set(Suffix ".lib")
        if(PYTHON_WINDOWS_USE_RELEASE_LIBS)
          add_definitions(-DORTHANC_PYTHON_WINDOWS_USE_RELEASE_LIBS=1)
        endif()
      else()
        list(GET CMAKE_FIND_LIBRARY_PREFIXES 0 Prefix)
        set(Suffix ".a")
      endif()
      
      set(PYTHON_LIBRARY_NAME ${Prefix}python${PYTHON_VERSION_MAJOR}${PYTHON_VERSION_MINOR}${Suffix})
    endif()
    
    if (CMAKE_COMPILER_IS_GNUCXX AND
        "${CMAKE_SIZEOF_VOID_P}" STREQUAL "8" AND
        "${PYTHON_VERSION}" STREQUAL "2.7")
      # Fix for MinGW 64bit: https://stackoverflow.com/a/19867426/881731
      add_definitions(-DMS_WIN64)
    endif()
    
    set(PYTHON_INCLUDE_DIRS ${PYTHON_WINDOWS_ROOT}/include)
    set(PYTHON_LIBRARIES ${PYTHON_WINDOWS_ROOT}/libs/${PYTHON_LIBRARY_NAME})
    
    execute_process(
      COMMAND 
      ${PYTHON_EXECUTABLE} ${ORTHANC_FRAMEWORK_ROOT}/../Resources/WindowsResources.py
      ${PLUGIN_VERSION} "Python plugin" OrthancPython.dll
      "Plugin to create Orthanc plugins using Python"
      ERROR_VARIABLE Failure
      OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/Version.rc
      )

    if (Failure)
      message(FATAL_ERROR "Error while computing the version information: ${Failure}")
    endif()

    set(WINDOWS_RESOURCES ${CMAKE_CURRENT_BINARY_DIR}/Version.rc)

  else()
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(PYTHON_1 python-${PYTHON_VERSION}-embed)

    if (PYTHON_1_FOUND)
      set(PYTHON_INCLUDE_DIRS ${PYTHON_1_INCLUDE_DIRS})
      set(PYTHON_LIBRARIES ${PYTHON_1_LIBRARIES})
    else()
      pkg_check_modules(PYTHON_2 REQUIRED python-${PYTHON_VERSION})
      set(PYTHON_INCLUDE_DIRS ${PYTHON_2_INCLUDE_DIRS})
      set(PYTHON_LIBRARIES ${PYTHON_2_LIBRARIES})
    endif()
  endif()
endif()


if (USE_FRAMEWORK_ORTHANC_SDK)
  include_directories(
    ${ORTHANC_FRAMEWORK_ROOT}/../../OrthancServer/Plugins/Include
    )
else()
  include_directories(
    ${CMAKE_SOURCE_DIR}/Resources/Orthanc/Sdk-1.10.0
    )
endif()

add_definitions(
  -DHAS_ORTHANC_EXCEPTION=0
  )

include_directories(
  ${PYTHON_INCLUDE_DIRS}
  )

add_library(OrthancPython SHARED
  Sources/Autogenerated/sdk.cpp
  Sources/DicomScpCallbacks.cpp
  Sources/ICallbackRegistration.cpp
  Sources/IncomingHttpRequestFilter.cpp
  Sources/IncomingInstanceFilter.cpp
  Sources/OnChangeCallback.cpp
  Sources/OnStoredInstanceCallback.cpp
  Sources/Plugin.cpp
  Sources/PythonBytes.cpp
  Sources/PythonFunction.cpp
  Sources/PythonLock.cpp
  Sources/PythonModule.cpp
  Sources/PythonObject.cpp
  Sources/PythonString.cpp
  Sources/ReceivedInstanceCallback.cpp
  Sources/RestCallbacks.cpp
  Sources/StorageArea.cpp
  Sources/StorageCommitmentScpCallback.cpp

  # Third-party sources
  ${CMAKE_SOURCE_DIR}/Resources/Orthanc/Plugins/OrthancPluginCppWrapper.cpp
  ${BOOST_SOURCES}
  ${JSONCPP_SOURCES}
  ${WINDOWS_RESOURCES}
  )

target_link_libraries(OrthancPython ${PYTHON_LIBRARIES})

add_definitions(-DPLUGIN_VERSION="${PLUGIN_VERSION}")

set_target_properties(OrthancPython PROPERTIES 
  VERSION ${PLUGIN_VERSION} 
  SOVERSION ${PLUGIN_VERSION}
  )

install(
  TARGETS OrthancPython
  RUNTIME DESTINATION lib    # Destination for Windows
  LIBRARY DESTINATION share/orthanc/plugins    # Destination for Linux
  )
