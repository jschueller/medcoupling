# - Config file for the SalomeKERNEL package
# It defines the following variables.
# Specific to the package SalomeKERNEL itself:
#  SALOMEKERNEL_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#
# Other stuff specific to this package:
#  SALOME_USE_MPI            - ON if KERNEL is built with MPI support
#  SALOME_KERNEL_BUILD_DOC   - ON if documentation for KERNEL module has been built
#  SALOME_KERNEL_BUILD_TESTS - ON if tests for KERNEL module has been built
#  SALOME_KERNEL_LIGHT_ONLY  - ON if SALOME is built in Light mode (no CORBA)

###############################################################
# Copyright (C) 2007-2022  CEA/DEN, EDF R&D, OPEN CASCADE
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
####### The input file was SalomeKERNELConfig.cmake.in                            ########

get_filename_component(PACKAGE_PREFIX_DIR "${CMAKE_CURRENT_LIST_DIR}/../../" ABSOLUTE)

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

# Load the dependencies for the libraries of SalomeKERNEL
# (contains definitions for IMPORTED targets). This is only
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET SALOMEBasics AND NOT SalomeKERNEL_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/salome_adm/cmake_files/SalomeKERNELTargets.cmake")
ENDIF()

# Package root dir:
SET_AND_CHECK(KERNEL_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

# Include directories and definitions
SET_AND_CHECK(KERNEL_INCLUDE_DIRS "${KERNEL_ROOT_DIR_EXP}/include/salome")
SET(KERNEL_INCLUDE_DIRS "${KERNEL_INCLUDE_DIRS};C:/work/SALOME-9.10.0/W64/EXT/include;C:/work/SALOME-9.10.0/W64/Python/include;C:/work/SALOME-9.10.0/W64/pthreads/include;C:/work/SALOME-9.10.0/W64/EXT/include/boost-1_67;C:/work/SALOME-9.10.0/W64/omniORB/include")
SET(KERNEL_DEFINITIONS)

# Package specific environment variables
SET(SalomeKERNEL_EXTRA_ENV LD_LIBRARY_PATH;PATH;PYTHONPATH)
SET(SalomeKERNEL_EXTRA_ENV_LD_LIBRARY_PATH C:/work/SALOME-9.10.0/W64/EXT/lib;C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/pthreads/lib;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/bin/x86_win32;${PACKAGE_PREFIX_DIR}/lib/salome)
SET(SalomeKERNEL_EXTRA_ENV_PATH C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/swig/bin;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/Python/Scripts)
SET(SalomeKERNEL_EXTRA_ENV_PYTHONPATH C:/work/SALOME-9.10.0/W64/Python/lib;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/lib/python;C:/work/SALOME-9.10.0/W64/Python/lib/site-packages;${PACKAGE_PREFIX_DIR}/bin/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome/shared_modules)

#### Now the specificities

# Options exported by the package:
SET(SALOME_USE_MPI     OFF)
IF(SALOME_USE_MPI)
  LIST(APPEND KERNEL_INCLUDE_DIRS "")
  LIST(APPEND KERNEL_DEFINITIONS "")
ENDIF()

SET(SALOME_KERNEL_BUILD_DOC   ON)
SET(SALOME_KERNEL_BUILD_TESTS ON)
SET(SALOME_KERNEL_LIGHT_ONLY  OFF)
SET(SALOME_USE_LIBBATCH       ON)
SET(SALOME_USE_64BIT_IDS      ON)

IF(SALOME_KERNEL_LIGHT_ONLY)
  ADD_DEFINITIONS(-DSALOME_LIGHT)
ENDIF()

# Prerequisites:
IF(SALOME_KERNEL_BUILD_TESTS)
  SET_AND_CHECK(CPPUNIT_ROOT_DIR_EXP  "C:/work/SALOME-9.10.0/W64/EXT")
ENDIF()
IF(SALOME_KERNEL_BUILD_DOC)
  SET_AND_CHECK(GRAPHVIZ_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
  SET_AND_CHECK(DOXYGEN_ROOT_DIR_EXP  "C:/work/SALOME-9.10.0/W64/EXT")
  SET_AND_CHECK(SPHINX_ROOT_DIR_EXP   "C:/work/SALOME-9.10.0/W64/Python")
ENDIF()
IF(SALOME_USE_MPI)
  SET_AND_CHECK(MPI_ROOT_DIR_EXP      "${PACKAGE_PREFIX_DIR}/")
ENDIF()
IF(NOT SALOME_KERNEL_LIGHT_ONLY)
  SET_AND_CHECK(OMNIORB_ROOT_DIR_EXP  "C:/work/SALOME-9.10.0/W64/omniORB")
  SET_AND_CHECK(OMNIORBPY_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/omniORB")
ENDIF()
IF(SALOME_USE_LIBBATCH)
  SET_AND_CHECK(LIBBATCH_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
ENDIF()

SET_AND_CHECK(PTHREAD_ROOT_DIR_EXP  "C:/work/SALOME-9.10.0/W64/pthreads")
SET_AND_CHECK(HDF5_ROOT_DIR_EXP     "C:/work/SALOME-9.10.0/W64/EXT")
SET_AND_CHECK(LIBXML2_ROOT_DIR_EXP  "C:/work/SALOME-9.10.0/W64/EXT")
SET_AND_CHECK(PYTHON_ROOT_DIR_EXP   "C:/work/SALOME-9.10.0/W64/Python")
SET_AND_CHECK(SWIG_ROOT_DIR_EXP     "C:/work/SALOME-9.10.0/W64/swig/bin")

# For all prerequisites, load the corresponding targets if the package was used
# in CONFIG mode. This ensures dependent projects link correctly
# without having to set LD_LIBRARY_PATH:
unset(Boost_USE_DEBUG_RUNTIME) # problem detected in 9.9.0 with persalys. After a first find_package (Boost) FIND_PACKAGE 15 lines under failed
SET(_PREREQ_SalomeKERNEL  LibBatch HDF5)
SET(_PREREQ_SalomeKERNEL_CONFIG_DIR  "C:/work/SALOME-9.10.0/W64/EXT/cmake" "C:/work/SALOME-9.10.0/W64/EXT/cmake/hdf5")
SET(_PREREQ_SalomeKERNEL_COMPONENTS ";;")
LIST(LENGTH _PREREQ_SalomeKERNEL_CONFIG_DIR _list_len_SalomeKERNEL)
IF(NOT _list_len_SalomeKERNEL EQUAL 0)
  # Another CMake stupidity - FOREACH(... RANGE r) generates r+1 numbers ...
  MATH(EXPR _range_SalomeKERNEL "${_list_len_SalomeKERNEL}-1")
  FOREACH(_p_SalomeKERNEL RANGE ${_range_SalomeKERNEL})
    LIST(GET _PREREQ_SalomeKERNEL            ${_p_SalomeKERNEL} _pkg_SalomeKERNEL    )
    LIST(GET _PREREQ_SalomeKERNEL_CONFIG_DIR ${_p_SalomeKERNEL} _pkg_dir_SalomeKERNEL)
    LIST(GET _PREREQ_SalomeKERNEL_COMPONENTS ${_p_SalomeKERNEL} _pkg_compo_SalomeKERNEL)
    IF(NOT OMIT_DETECT_PACKAGE_${_pkg_SalomeKERNEL})
      MESSAGE(STATUS "===> Reloading targets from ${_pkg_SalomeKERNEL} ...")
      IF(NOT _pkg_compo_SalomeKERNEL)
        FIND_PACKAGE(${_pkg_SalomeKERNEL} REQUIRED NO_MODULE
            PATHS "${_pkg_dir_SalomeKERNEL}"
            NO_DEFAULT_PATH)
      ELSE()
        STRING(REPLACE "," ";" _compo_lst_SalomeKERNEL "${_pkg_compo_SalomeKERNEL}")
        MESSAGE(STATUS "===> (components: ${_pkg_compo_SalomeKERNEL})")
        FIND_PACKAGE(${_pkg_SalomeKERNEL} REQUIRED NO_MODULE
            COMPONENTS ${_compo_lst_SalomeKERNEL}
            PATHS "${_pkg_dir_SalomeKERNEL}"
            NO_DEFAULT_PATH)
      ENDIF()
    ENDIF()
  ENDFOREACH()
ENDIF()

# Installation directories
SET(SALOME_INSTALL_BINS "bin/salome")
SET(SALOME_INSTALL_LIBS "lib/salome")
SET(SALOME_INSTALL_IDLS "idl/salome")
SET(SALOME_INSTALL_HEADERS "include/salome")
SET(SALOME_INSTALL_SCRIPT_SCRIPTS "bin/salome")
SET(SALOME_INSTALL_SCRIPT_DATA "bin/salome")
SET(SALOME_INSTALL_SCRIPT_PYTHON "bin/salome")
SET(SALOME_INSTALL_APPLISKEL_SCRIPTS "bin/salome/appliskel")
SET(SALOME_INSTALL_APPLISKEL_PYTHON "bin/salome/appliskel")
SET(SALOME_INSTALL_CMAKE "salome_adm/cmake_files")
SET(SALOME_INSTALL_CMAKE_LOCAL "adm_local/cmake_files")
SET(SALOME_INSTALL_PYTHON "lib/python3.6/site-packages/salome")
SET(SALOME_INSTALL_PYTHON_SHARED "lib/python3.6/site-packages/salome/shared_modules")
SET(SALOME_INSTALL_RES "share/salome/resources")
SET(SALOME_INSTALL_DOC "share/doc/salome")
SET(SALOME_INSTALL_AMCONFIG "salome_adm/unix") # to be removed
SET(SALOME_INSTALL_AMCONFIG_LOCAL "adm_local/unix") # to be removed

# Exposed targets:
SET(KERNEL_CalciumC CalciumC)
SET(KERNEL_DF DF)
SET(KERNEL_Launcher Launcher)
SET(KERNEL_LifeCycleCORBATest LifeCycleCORBATest)
SET(KERNEL_NamingServiceTest NamingServiceTest)
SET(KERNEL_OpUtil OpUtil)
SET(KERNEL_Registry Registry)
SET(KERNEL_ResourcesManager ResourcesManager)
SET(KERNEL_SALOMEBasics SALOMEBasics)
SET(KERNEL_SalomeCatalog SalomeCatalog)
SET(KERNEL_SalomeCommunication SalomeCommunication)
SET(KERNEL_SalomeContainer SalomeContainer)
SET(KERNEL_SalomeSDS SalomeSDS)
SET(KERNEL_SalomeDatastream SalomeDatastream)
SET(KERNEL_SalomeDSCContainer SalomeDSCContainer)
SET(KERNEL_SalomeDSClient SalomeDSClient)
SET(KERNEL_SalomeDSCSupervBasic SalomeDSCSupervBasic)
SET(KERNEL_SalomeDSCSuperv SalomeDSCSuperv)
SET(KERNEL_SalomeDSImpl SalomeDSImpl)
SET(KERNEL_SALOMEDSImplTest SALOMEDSImplTest)
SET(KERNEL_SalomeDS SalomeDS)
SET(KERNEL_SALOMEDSTest SALOMEDSTest)
SET(KERNEL_SalomeGenericObj SalomeGenericObj)
SET(KERNEL_SalomeHDFPersist SalomeHDFPersist)
SET(KERNEL_SalomeIDLKernel SalomeIDLKernel)
SET(KERNEL_SalomeLauncher SalomeLauncher)
SET(KERNEL_SalomeLifeCycleCORBA SalomeLifeCycleCORBA)
SET(KERNEL_SALOMELocalTrace SALOMELocalTrace)
SET(KERNEL_SALOMELocalTraceTest SALOMELocalTraceTest)
SET(KERNEL_SalomeLoggerServer SalomeLoggerServer)
SET(KERNEL_SalomeMPIContainer SalomeMPIContainer)
SET(KERNEL_SalomeNotification SalomeNotification)
SET(KERNEL_SalomeNS SalomeNS)
SET(KERNEL_SalomeResourcesManager SalomeResourcesManager)
SET(KERNEL_SalomeTestComponentEngine SalomeTestComponentEngine)
SET(KERNEL_SalomeTestMPIComponentEngine SalomeTestMPIComponentEngine)
SET(KERNEL_SALOMETraceCollectorTest SALOMETraceCollectorTest)
SET(KERNEL_TOOLSDS TOOLSDS)
SET(KERNEL_UtilsTest UtilsTest)
SET(KERNEL_with_loggerTraceCollector with_loggerTraceCollector)
SET(KERNEL_SalomeKernelHelpers SalomeKernelHelpers)
SET(KERNEL_SalomeORB SalomeORB)
