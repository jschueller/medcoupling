# - Config file for the MEDCoupling package
# It defines the following variables. 
# Specific to the package MEDCoupling itself:
#  MEDCOUPLING_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#

###############################################################
# Copyright (C) 2013-2022  CEA/DEN, EDF R&D, OPEN CASCADE
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
####### The input file was MEDCouplingConfig.cmake.in                            ########

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

# Load the dependencies for the libraries of MEDCoupling 
# (contains definitions for IMPORTED targets). This is only 
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET medcouplingcpp AND NOT MEDCoupling_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/cmake_files/MEDCouplingTargets.cmake")
ENDIF()   

# Package root dir:
SET_AND_CHECK(MEDCOUPLING_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

# Include directories and definitions
SET_AND_CHECK(MEDCOUPLING_INCLUDE_DIRS "${MEDCOUPLING_ROOT_DIR_EXP}/include")
SET(MEDCOUPLING_INCLUDE_DIRS "${MEDCOUPLING_INCLUDE_DIRS};C:/work/SALOME-9.10.0/W64/EXT/include;C:/work/SALOME-9.10.0/W64/EXT/include/boost-1_67;C:/work/SALOME-9.10.0/W64/Python/include")
SET(MEDCOUPLING_DEFINITIONS)

# Package specific environment variables
SET(MEDCoupling_EXTRA_ENV LD_LIBRARY_PATH;PATH;PYTHONPATH)
SET(MEDCoupling_EXTRA_ENV_LD_LIBRARY_PATH C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/EXT/lib;C:/work/SALOME-9.10.0/W64/Python)
SET(MEDCoupling_EXTRA_ENV_PATH C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/swig/bin;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/Python/Scripts)
SET(MEDCoupling_EXTRA_ENV_PYTHONPATH C:/work/SALOME-9.10.0/W64/Python/lib;C:/work/SALOME-9.10.0/W64/Python/lib/site-packages)

#### Now the specificities

# Options exported by the package:
SET(MEDCOUPLING_MICROMED       OFF)
SET(MEDCOUPLING_ENABLE_PYTHON  ON)
SET(MEDCOUPLING_USE_MPI            OFF)
SET(MEDCOUPLING_BUILD_DOC      ON)
SET(MEDCOUPLING_BUILD_TESTS    ON)
SET(MEDCOUPLING_BUILD_GUI      )
SET(MEDCOUPLING_USE_64BIT_IDS  ON)

# Advanced options

# Level 1 prerequisites:

# Optional level 1 prerequisites:

IF(NOT MEDCOUPLING_MICROMED)
  SET_AND_CHECK(MEDFILE_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
ENDIF()

# For all prerequisites, load the corresponding targets if the package was used
# in CONFIG mode. This ensures dependent projects link correctly
# without having to set LD_LIBRARY_PATH:
SET(_PREREQ_MEDCoupling  MEDFile)
SET(_PREREQ_MEDCoupling_CONFIG_DIR  "C:/work/SALOME-9.10.0/W64/EXT/cmake")
SET(_PREREQ_MEDCoupling_COMPONENTS ";")
LIST(LENGTH _PREREQ_MEDCoupling_CONFIG_DIR _list_len_MEDCoupling)
IF(NOT _list_len_MEDCoupling EQUAL 0)
  # Another CMake stupidity - FOREACH(... RANGE r) generates r+1 numbers ...
  MATH(EXPR _range_MEDCoupling "${_list_len_MEDCoupling}-1")
  FOREACH(_p_MEDCoupling RANGE ${_range_MEDCoupling})
    LIST(GET _PREREQ_MEDCoupling            ${_p_MEDCoupling} _pkg_MEDCoupling    )
    LIST(GET _PREREQ_MEDCoupling_CONFIG_DIR ${_p_MEDCoupling} _pkg_dir_MEDCoupling)
    LIST(GET _PREREQ_MEDCoupling_COMPONENTS ${_p_MEDCoupling} _pkg_compo_MEDCoupling)
    IF(NOT OMIT_DETECT_PACKAGE_${_pkg_MEDCoupling})
      MESSAGE(STATUS "===> Reloading targets from ${_pkg_MEDCoupling} ...")
      IF(NOT _pkg_compo_MEDCoupling)
        FIND_PACKAGE(${_pkg_MEDCoupling} REQUIRED NO_MODULE
            PATHS "${_pkg_dir_MEDCoupling}"
            NO_DEFAULT_PATH)
      ELSE()
        STRING(REPLACE "," ";" _compo_lst_MEDCoupling "${_pkg_compo_MEDCoupling}")
        MESSAGE(STATUS "===> (components: ${_pkg_compo_MEDCoupling})")
        FIND_PACKAGE(${_pkg_MEDCoupling} REQUIRED NO_MODULE
            COMPONENTS ${_compo_lst_MEDCoupling}
            PATHS "${_pkg_dir_MEDCoupling}"
            NO_DEFAULT_PATH)
      ENDIF()
    ENDIF()
  ENDFOREACH()
ENDIF()

# Installation directories
SET(MEDCOUPLING_INSTALL_BINS "bin")
SET(MEDCOUPLING_INSTALL_LIBS "bin")
SET(MEDCOUPLING_INSTALL_HEADERS "bin")
SET(MEDCOUPLING_INSTALL_SCRIPT_SCRIPTS "bin")
SET(MEDCOUPLING_INSTALL_TESTS "bin")
SET(MEDCOUPLING_INSTALL_SCRIPT_PYTHON "bin")
SET(MEDCOUPLING_INSTALL_CMAKE_LOCAL "bin")
IF(MEDCOUPLING_ENABLE_PYTHON)
  SET(MEDCOUPLING_INSTALL_PYTHON "bin")
  SET(MEDCOUPLING_INSTALL_PYTHON_SHARED "bin")
ENDIF(MEDCOUPLING_ENABLE_PYTHON)
SET(MEDCOUPLING_INSTALL_RES "bin")
SET(MEDCOUPLING_INSTALL_DOC "bin")

# Exposed MEDCoupling targets:
SET(MEDCoupling_interpkernel interpkernel)
SET(MEDCoupling_medcouplingcpp medcouplingcpp)
SET(MEDCoupling_medcoupling    medcouplingcpp)
SET(MEDCoupling_medicoco    medicoco)
SET(MEDCoupling_medcouplingremapper medcouplingremapper)
SET(MEDCoupling_medloader medloader)
SET(MEDCoupling_renumbercpp renumbercpp)
SET(MEDCoupling_medpartitionercpp medpartitionercpp)
SET(MEDCoupling_MEDPARTITIONERTest MEDPARTITIONERTest)
SET(MEDCoupling_InterpKernelTest InterpKernelTest)
SET(MEDCoupling_paramedmem paramedmem)
SET(MEDCoupling_paramedloader paramedloader)
SET(MEDCoupling_paramedmemcompo paramedmemcompo)
SET(MEDCoupling_ParaMEDMEMTest ParaMEDMEMTest)
SET(MEDCoupling_medcouplingclient medcouplingclient)
