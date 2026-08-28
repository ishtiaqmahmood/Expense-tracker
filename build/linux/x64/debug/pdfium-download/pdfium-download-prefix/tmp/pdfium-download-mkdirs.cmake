# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file LICENSE.rst or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION ${CMAKE_VERSION}) # this file comes with cmake

# If CMAKE_DISABLE_SOURCE_CHANGES is set to true and the source directory is an
# existing directory in our source tree, calling file(MAKE_DIRECTORY) on it
# would cause a fatal error, even though it would be a no-op.
if(NOT EXISTS "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-src")
  file(MAKE_DIRECTORY "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-src")
endif()
file(MAKE_DIRECTORY
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-build"
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix"
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/tmp"
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp"
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/src"
  "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp"
)

set(configSubDirs )
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "/home/acer/Flutter/expense/build/linux/x64/debug/pdfium-download/pdfium-download-prefix/src/pdfium-download-stamp${cfgdir}") # cfgdir has leading slash
endif()
