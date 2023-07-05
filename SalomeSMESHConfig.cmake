# - Config file for the SalomeSMESH package
# It defines the following variables. 
# Specific to the package SalomeSMESH itself:
#  SALOMESMESH_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#

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
####### The input file was SalomeSMESHConfig.cmake.in                            ########

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

# Load the dependencies for the libraries of SalomeSMESH 
# (contains definitions for IMPORTED targets). This is only 
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET SMESHEngine AND NOT SalomeSMESH_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/adm_local/cmake_files/SalomeSMESHTargets.cmake")
ENDIF()   

# Package root dir:
SET_AND_CHECK(SMESH_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

# Include directories
SET_AND_CHECK(SMESH_INCLUDE_DIRS "${SMESH_ROOT_DIR_EXP}/include/salome")
SET(SMESH_INCLUDE_DIRS "${SMESH_INCLUDE_DIRS};C:/work/SALOME-9.10.0/W64/Python/include;C:/work/SALOME-9.10.0/W64/pthreads/include;C:/work/SALOME-9.10.0/W64/EXT/include/boost-1_67;C:/work/SALOME-9.10.0/W64/omniORB/include;C:/work/SALOME-9.10.0/W64/EXT/include;C:/work/SALOME-9.10.0/W64/qt/include/;C:/work/SALOME-9.10.0/W64/qt/include/QtCore;C:/work/SALOME-9.10.0/W64/qt/.//mkspecs/win32-msvc;C:/work/SALOME-9.10.0/W64/qt/include/QtGui;C:/work/SALOME-9.10.0/W64/qt/include/QtWidgets;C:/work/SALOME-9.10.0/W64/qt/include/QtNetwork;C:/work/SALOME-9.10.0/W64/qt/include/QtXml;C:/work/SALOME-9.10.0/W64/qt/include/QtOpenGL;C:/work/SALOME-9.10.0/W64/qt/include/QtPrintSupport;C:/work/SALOME-9.10.0/W64/qt/include/QtHelp;C:/work/SALOME-9.10.0/W64/qt/include/QtSql;C:/work/SALOME-9.10.0/W64/qt/include/QtTest;C:/work/SALOME-9.10.0/W64/qwt/include;C:/work/SALOME-9.10.0/W64/CAS/inc")
SET(SMESH_DEFINITIONS "-DWITH_SALOMEDS_OBSERVER;-DVTK_OPENGL2;-DWITH_OPENCV;-DWITH_VTK")

# Package specific environment variables
SET(SalomeSMESH_EXTRA_ENV LD_LIBRARY_PATH;PATH;PYTHONPATH;PV_PLUGIN_PATH)
SET(SalomeSMESH_EXTRA_ENV_LD_LIBRARY_PATH C:/work/SALOME-9.10.0/W64/EXT/lib;C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/pthreads/lib;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/bin/x86_win32;C:/work/SALOME-9.10.0/W64/KERNEL/lib/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/lib;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/bin;C:/work/SALOME-9.10.0/W64/qt/bin;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;C:/work/SALOME-9.10.0/W64/qwt/lib;C:/work/SALOME-9.10.0/W64/GUI/lib/salome;C:/work/SALOME-9.10.0/W64/EXT/x64/vc15/bin;C:/work/SALOME-9.10.0/W64/GEOM/lib/salome;C:/work/SALOME-9.10.0/W64/SHAPER/lib/salome;C:/work/SALOME-9.10.0/W64/SHAPERSTUDY/lib/salome;${PACKAGE_PREFIX_DIR}/lib/salome)
SET(SalomeSMESH_EXTRA_ENV_PATH C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/swig/bin;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/Python/Scripts;C:/work/SALOME-9.10.0/W64/sip/Scripts;C:/work/SALOME-9.10.0/W64/PyQt/bin)
SET(SalomeSMESH_EXTRA_ENV_PYTHONPATH C:/work/SALOME-9.10.0/W64/Python/lib;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/lib/python;C:/work/SALOME-9.10.0/W64/Python/lib/site-packages;C:/work/SALOME-9.10.0/W64/KERNEL/bin/salome;C:/work/SALOME-9.10.0/W64/KERNEL/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;C:/work/SALOME-9.10.0/W64/GUI/bin/salome;C:/work/SALOME-9.10.0/W64/GUI/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/GUI/lib/salome;C:/work/SALOME-9.10.0/W64/GEOM/bin/salome;C:/work/SALOME-9.10.0/W64/GEOM/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/GEOM/lib/python3.6/site-packages/salome/shared_modules;C:/work/SALOME-9.10.0/W64/SHAPER/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/SHAPERSTUDY/bin/salome;C:/work/SALOME-9.10.0/W64/SHAPERSTUDY/lib/python3.6/site-packages/salome;${PACKAGE_PREFIX_DIR}/bin/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome/shared_modules)
SET(SalomeSMESH_EXTRA_ENV_PV_PLUGIN_PATH C:/work/SALOME-9.10.0/W64/ParaView/bin)

#### Now the specificities

# Options exported by the package:
SET(SALOME_SMESH_BUILD_DOC ON)
SET(SALOME_SMESH_BUILD_TESTS ON)

# Advanced options
SET(SALOME_SMESH_BUILD_GUI ON)
SET(SALOME_SMESH_USE_CGNS  ON)
SET(SALOME_SMESH_USE_TBB   ON)
SET(SALOME_SMESH_DISABLE_MG_ADAPT ON)
SET(SALOME_SMESH_DISABLE_HOMARD_ADAPT ON)
IF(SALOME_SMESH_DISABLE_MG_ADAPT)
  LIST(APPEND SMESH_DEFINITIONS "-DDISABLE_MG_ADAPT")
ENDIF()

# Level 1 prerequisites:
SET_AND_CHECK(GEOM_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/GEOM")
SET_AND_CHECK(MEDFILE_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")

# Optional level 1 prerequisites:
IF(SALOME_SMESH_USE_CGNS)
  SET_AND_CHECK(CGNS_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
ENDIF()
IF(SALOME_SMESH_USE_TBB)
  SET_AND_CHECK(TBB_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
ENDIF()

# For all prerequisites, load the corresponding targets if the package was used
# in CONFIG mode. This ensures dependent projects link correctly
# without having to set LD_LIBRARY_PATH:
SET(_PREREQ_SalomeSMESH  MEDCoupling MEDFile)
SET(_PREREQ_SalomeSMESH_CONFIG_DIR  "C:/work/SALOME-9.10.0/W64/MEDCOUPLING/cmake_files" "C:/work/SALOME-9.10.0/W64/EXT/cmake")
SET(_PREREQ_SalomeSMESH_COMPONENTS ";;")
LIST(LENGTH _PREREQ_SalomeSMESH_CONFIG_DIR _list_len_SalomeSMESH)
IF(NOT _list_len_SalomeSMESH EQUAL 0)
  # Another CMake stupidity - FOREACH(... RANGE r) generates r+1 numbers ...
  MATH(EXPR _range_SalomeSMESH "${_list_len_SalomeSMESH}-1")
  FOREACH(_p_SalomeSMESH RANGE ${_range_SalomeSMESH})
    LIST(GET _PREREQ_SalomeSMESH            ${_p_SalomeSMESH} _pkg_SalomeSMESH    )
    LIST(GET _PREREQ_SalomeSMESH_CONFIG_DIR ${_p_SalomeSMESH} _pkg_dir_SalomeSMESH)
    LIST(GET _PREREQ_SalomeSMESH_COMPONENTS ${_p_SalomeSMESH} _pkg_compo_SalomeSMESH)
    IF(NOT OMIT_DETECT_PACKAGE_${_pkg_SalomeSMESH})
      MESSAGE(STATUS "===> Reloading targets from ${_pkg_SalomeSMESH} ...")
      IF(NOT _pkg_compo_SalomeSMESH)
        FIND_PACKAGE(${_pkg_SalomeSMESH} REQUIRED NO_MODULE
            PATHS "${_pkg_dir_SalomeSMESH}"
            NO_DEFAULT_PATH)
      ELSE()
        STRING(REPLACE "," ";" _compo_lst_SalomeSMESH "${_pkg_compo_SalomeSMESH}")
        MESSAGE(STATUS "===> (components: ${_pkg_compo_SalomeSMESH})")
        FIND_PACKAGE(${_pkg_SalomeSMESH} REQUIRED NO_MODULE
            COMPONENTS ${_compo_lst_SalomeSMESH}
            PATHS "${_pkg_dir_SalomeSMESH}"
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
SET(SALOME_INSTALL_CMAKE_LOCAL "adm_local/cmake_files")
SET(SALOME_INSTALL_PYTHON "lib/python3.6/site-packages/salome")
SET(SALOME_INSTALL_PYTHON_SHARED "lib/python3.6/site-packages/salome/shared_modules")
SET(SALOME_INSTALL_RES "share/salome/resources")
SET(SALOME_INSTALL_DOC "share/doc/salome")
SET(SALOME_INSTALL_AMCONFIG_LOCAL "adm_local/unix")
SET(SALOME_USE_64BIT_IDS  ON)

# Include GEOM targets if they were not already loaded:
IF(NOT (TARGET GEOMbasic))
  INCLUDE("${GEOM_ROOT_DIR_EXP}/${SALOME_INSTALL_CMAKE_LOCAL}/SalomeGEOMTargets.cmake")
ENDIF(NOT (TARGET GEOMbasic))

# Exposed SMESH targets:
SET(SMESH_SMESHControls SMESHControls)
SET(SMESH_MeshDriver MeshDriver)
SET(SMESH_MeshDriverCGNS MeshDriverCGNS)
SET(SMESH_MeshDriverDAT MeshDriverDAT)
SET(SMESH_MeshDriverGMF MeshDriverGMF)
SET(SMESH_MeshDriverMED MeshDriverMED)
SET(SMESH_MeshDriverSTL MeshDriverSTL)
SET(SMESH_MeshDriverUNV MeshDriverUNV)
SET(SMESH_MEDWrapper MEDWrapper)
SET(SMESH_SMESHObject SMESHObject)
SET(SMESH_PluginUtils PluginUtils)
SET(SMESH_SMDS SMDS)
SET(SMESH_SMESHimpl SMESHimpl)
SET(SMESH_SMESHEngine SMESHEngine)
SET(SMESH_SMESHClient SMESHClient)
SET(SMESH_SMESHDS SMESHDS)
SET(SMESH_SMESHFiltersSelection SMESHFiltersSelection)
SET(SMESH_SMESH SMESH)
SET(SMESH_SMESHUtils SMESHUtils)
SET(SMESH_StdMeshers StdMeshers)
SET(SMESH_StdMeshersEngine StdMeshersEngine)
SET(SMESH_StdMeshersGUI StdMeshersGUI)
SET(SMESH_MeshJobManagerEngine MeshJobManagerEngine)
SET(SMESH_SPADDERPluginTesterEngine SPADDERPluginTesterEngine)
SET(SMESH_SalomeIDLSMESH SalomeIDLSMESH)
SET(SMESH_SalomeIDLSPADDER SalomeIDLSPADDER)
