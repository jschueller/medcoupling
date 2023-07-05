# - Config file for the LibBatch package
# It defines the following variables. 
# Specific to the pacakge LibBatch itself:
#  LIBBATCH_INCLUDE_DIRS - include directories 
#  LIBBATCH_LIBRARIES    - libraries to link against
#  LIBBATCH_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#
# Other stuff specific to this package:
#  1. Some flags:
#   LIBBATCH_LOCAL_SUBMISSION - boolean indicating whether LibBatch was built with the 
#   local submission support.
#   LIBBATCH_PYTHON_WRAPPING  - boolean indicating whether the Python wrapping was built.
#   LIBBATCH_PYTHONPATH       - (if above is True) path to the Python wrapping. 

###############################################################
# Copyright (C) 2007-2021  CEA/DEN, EDF R&D, OPEN CASCADE
#
# Copyright (C) 2003-2007  OPEN CASCADE, EADS/CCR, LIP6, CEA/DEN,
# CEDRAT, EDF R&D, LEG, PRINCIPIA R&D, BUREAU VERITAS
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
# See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
#

### Initialisation performed by CONFIGURE_PACKAGE_CONFIG_FILE:

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was LibBatchConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../" ABSOLUTE)

macro(set_and_check _var _file)
  set(${_var} "${_file}")
  if(NOT EXISTS "${_file}")
    message(FATAL_ERROR "File or directory ${_file} referenced by variable ${_var} does not exist !")
  endif()
endmacro()

macro(check_required_components _NAME)
  foreach(comp ${${_NAME}_FIND_COMPONENTS})
    if(NOT ${_NAME}_${comp}_FOUND)
      if(${_NAME}_FIND_REQUIRED_${comp})
        set(${_NAME}_FOUND FALSE)
      endif()
    endif()
  endforeach()
endmacro()

####################################################################################

### First the generic stuff for a standard module:
SET(LIBBATCH_INCLUDE_DIRS "${PACKAGE_PREFIX_DIR}/include")

# Load the dependencies for the libraries of LibBatch 
# (contains definitions for IMPORTED targets). This is only 
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT batch AND NOT LibBatch_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/cmake/LibBatchTargets.cmake")
ENDIF()   

# These are IMPORTED targets created by LibBatchTargets.cmake
SET(LIBBATCH_LIBRARIES batch)

# Package root dir:
SET_AND_CHECK(LIBBATCH_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

#### Now the specificities

# Options exported by the package:
SET(LIBBATCH_LOCAL_SUBMISSION TRUE)
SET(LIBBATCH_PYTHON_WRAPPING TRUE)

SET_AND_CHECK(PTHREAD_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/pthreads")

IF(LIBBATCH_PYTHON_WRAPPING)
  SET_AND_CHECK(LIBBATCH_PYTHONPATH "${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages")
  SET_AND_CHECK(PYTHON_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/Python")
  SET_AND_CHECK(SWIG_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/swig/bin")
ENDIF()

