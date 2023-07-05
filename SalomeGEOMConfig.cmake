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

# - Config file for the SalomeGEOM package
# It defines the following variables. 
# Specific to the package SalomeGEOM itself:
#  SALOMEGEOM_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#

### Initialisation performed by CONFIGURE_PACKAGE_CONFIG_FILE:

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was SalomeGEOMConfig.cmake.in                            ########

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

# Load the dependencies for the libraries of SalomeGEOM 
# (contains definitions for IMPORTED targets). This is only 
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET GEOMbasic AND NOT SalomeGEOM_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/adm_local/cmake_files/SalomeGEOMTargets.cmake")
ENDIF()   

# Package root dir:
SET_AND_CHECK(GEOM_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

# Include directories
SET_AND_CHECK(GEOM_INCLUDE_DIRS "${GEOM_ROOT_DIR_EXP}/include/salome")
SET(GEOM_INCLUDE_DIRS "${GEOM_INCLUDE_DIRS};C:/work/SALOME-9.10.0/W64/Python/include;C:/work/SALOME-9.10.0/W64/pthreads/include;C:/work/SALOME-9.10.0/W64/EXT/include/boost-1_67;C:/work/SALOME-9.10.0/W64/omniORB/include;C:/work/SALOME-9.10.0/W64/EXT/include;C:/work/SALOME-9.10.0/W64/qt/include/;C:/work/SALOME-9.10.0/W64/qt/include/QtCore;C:/work/SALOME-9.10.0/W64/qt/.//mkspecs/win32-msvc;C:/work/SALOME-9.10.0/W64/qt/include/QtGui;C:/work/SALOME-9.10.0/W64/qt/include/QtWidgets;C:/work/SALOME-9.10.0/W64/qt/include/QtNetwork;C:/work/SALOME-9.10.0/W64/qt/include/QtXml;C:/work/SALOME-9.10.0/W64/qt/include/QtOpenGL;C:/work/SALOME-9.10.0/W64/qt/include/QtPrintSupport;C:/work/SALOME-9.10.0/W64/qt/include/QtHelp;C:/work/SALOME-9.10.0/W64/qt/include/QtSql;C:/work/SALOME-9.10.0/W64/qt/include/QtTest;C:/work/SALOME-9.10.0/W64/CAS/inc")
SET(GEOM_DEFINITIONS "")

# Package specific environment variables
SET(SalomeGEOM_EXTRA_ENV LD_LIBRARY_PATH;PATH;PYTHONPATH;PV_PLUGIN_PATH)
SET(SalomeGEOM_EXTRA_ENV_LD_LIBRARY_PATH C:/work/SALOME-9.10.0/W64/EXT/lib;C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/pthreads/lib;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/bin/x86_win32;C:/work/SALOME-9.10.0/W64/KERNEL/lib/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/lib;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/bin;C:/work/SALOME-9.10.0/W64/qt/bin;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;C:/work/SALOME-9.10.0/W64/qwt/lib;C:/work/SALOME-9.10.0/W64/GUI/lib/salome;C:/work/SALOME-9.10.0/W64/EXT/x64/vc15/bin;${PACKAGE_PREFIX_DIR}/lib/salome)
SET(SalomeGEOM_EXTRA_ENV_PATH C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/swig/bin;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/Python/Scripts;C:/work/SALOME-9.10.0/W64/sip/Scripts;C:/work/SALOME-9.10.0/W64/PyQt/bin)
SET(SalomeGEOM_EXTRA_ENV_PYTHONPATH C:/work/SALOME-9.10.0/W64/Python/lib;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/lib/python;C:/work/SALOME-9.10.0/W64/Python/lib/site-packages;C:/work/SALOME-9.10.0/W64/KERNEL/bin/salome;C:/work/SALOME-9.10.0/W64/KERNEL/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;C:/work/SALOME-9.10.0/W64/GUI/bin/salome;C:/work/SALOME-9.10.0/W64/GUI/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/GUI/lib/salome;${PACKAGE_PREFIX_DIR}/bin/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome/shared_modules)
SET(SalomeGEOM_EXTRA_ENV_PV_PLUGIN_PATH C:/work/SALOME-9.10.0/W64/ParaView/bin)

#### Now the specificities

# Options exported by the package:
SET(SALOME_GEOM_BUILD_DOC    ON)
SET(SALOME_GEOM_BUILD_TESTS  ON)

# Advanced options
SET(SALOME_GEOM_BUILD_GUI  ON)
SET(SALOME_GEOM_USE_OPENCV ON)
SET(SALOME_GEOM_USE_VTK ON)

# Level 1 prerequisites:
SET_AND_CHECK(KERNEL_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/KERNEL")
SET_AND_CHECK(OPENCASCADE_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/CAS")

# Optional level 1 prerequisites:
IF(SALOME_GEOM_BUILD_GUI)
  SET_AND_CHECK(GUI_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/GUI")
  LIST(APPEND GEOM_DEFINITIONS   "-DWITH_SALOMEDS_OBSERVER;-DVTK_OPENGL2")
ENDIF()
IF(SALOME_GEOM_USE_OPENCV)
  SET_AND_CHECK(OPENCV_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/EXT")
  LIST(APPEND GEOM_DEFINITIONS "-DWITH_OPENCV")
ENDIF()
IF(SALOME_GEOM_USE_VTK)
  SET_AND_CHECK(VTK_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/ParaView")
  LIST(APPEND GEOM_DEFINITIONS "-DWITH_VTK")
ENDIF()

# For all prerequisites, load the corresponding targets if the package was used
# in CONFIG mode. This ensures dependent projects link correctly
# without having to set LD_LIBRARY_PATH:
SET(_PREREQ_SalomeGEOM  OpenCV OpenCASCADE VTK)
SET(_PREREQ_SalomeGEOM_CONFIG_DIR  "C:/work/SALOME-9.10.0/W64/EXT" "C:/work/SALOME-9.10.0/W64/CAS/cmake" "C:/work/SALOME-9.10.0/W64/ParaView/lib/cmake/paraview-5.11/vtk")
SET(_PREREQ_SalomeGEOM_COMPONENTS ";;RenderingLOD,RenderingAnnotation,FiltersParallel,IOExport,WrappingPythonCore,IOXML,FiltersVerdict,RenderingLabel,InteractionWidgets,InfovisCore,InteractionStyle,CommonSystem;")
LIST(LENGTH _PREREQ_SalomeGEOM_CONFIG_DIR _list_len_SalomeGEOM)
IF(NOT _list_len_SalomeGEOM EQUAL 0)
  # Another CMake stupidity - FOREACH(... RANGE r) generates r+1 numbers ...
  MATH(EXPR _range_SalomeGEOM "${_list_len_SalomeGEOM}-1")
  FOREACH(_p_SalomeGEOM RANGE ${_range_SalomeGEOM})
    LIST(GET _PREREQ_SalomeGEOM            ${_p_SalomeGEOM} _pkg_SalomeGEOM    )
    LIST(GET _PREREQ_SalomeGEOM_CONFIG_DIR ${_p_SalomeGEOM} _pkg_dir_SalomeGEOM)
    LIST(GET _PREREQ_SalomeGEOM_COMPONENTS ${_p_SalomeGEOM} _pkg_compo_SalomeGEOM)
    IF(NOT OMIT_DETECT_PACKAGE_${_pkg_SalomeGEOM})
      MESSAGE(STATUS "===> Reloading targets from ${_pkg_SalomeGEOM} ...")
      IF(NOT _pkg_compo_SalomeGEOM)
        FIND_PACKAGE(${_pkg_SalomeGEOM} REQUIRED NO_MODULE
            PATHS "${_pkg_dir_SalomeGEOM}"
            NO_DEFAULT_PATH)
      ELSE()
        STRING(REPLACE "," ";" _compo_lst_SalomeGEOM "${_pkg_compo_SalomeGEOM}")
        MESSAGE(STATUS "===> (components: ${_pkg_compo_SalomeGEOM})")
        FIND_PACKAGE(${_pkg_SalomeGEOM} REQUIRED NO_MODULE
            COMPONENTS ${_compo_lst_SalomeGEOM}
            PATHS "${_pkg_dir_SalomeGEOM}"
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
SET(SALOME_INSTALL_CMAKE "salome_adm/cmake_files")
SET(SALOME_INSTALL_CMAKE_LOCAL "adm_local/cmake_files")
SET(SALOME_INSTALL_PYTHON "lib/python3.6/site-packages/salome")
SET(SALOME_INSTALL_PYTHON_SHARED "lib/python3.6/site-packages/salome/shared_modules")
SET(SALOME_INSTALL_RES "share/salome/resources")
SET(SALOME_INSTALL_DOC "share/doc/salome")
SET(SALOME_INSTALL_AMCONFIG_LOCAL "adm_local/unix")

IF(SALOME_GEOM_BUILD_GUI) 
  # Include GUI targets if they were not already loaded:
  IF(NOT (TARGET Event)) 
    INCLUDE("${GUI_ROOT_DIR_EXP}/${SALOME_INSTALL_CMAKE_LOCAL}/SalomeGUITargets.cmake")
  ENDIF()
ELSE(SALOME_GEOM_BUILD_GUI) 
  # Include KERNEL targets if they were not already loaded:
  IF(NOT (TARGET SALOMEBasics) AND NOT SALOME_MED_STANDALONE) 
    INCLUDE("${KERNEL_ROOT_DIR_EXP}/${SALOME_INSTALL_CMAKE}/SalomeKERNELTargets.cmake")
  ENDIF()
ENDIF(SALOME_GEOM_BUILD_GUI)

# Exposed GEOM targets:
SET(GEOM_GEOMArchimede GEOMArchimede)
SET(GEOM_BlockFix BlockFix)
SET(GEOM_GEOMbasic GEOMbasic)
SET(GEOM_GEOMAlgo GEOMAlgo)
SET(GEOM_GEOMClient GEOMClient)
SET(GEOM_GEOMImpl GEOMImpl)
SET(GEOM_GEOMUtils GEOMUtils)
SET(GEOM_GEOMEngine GEOMEngine)
SET(GEOM_GEOM_SupervEngine GEOM_SupervEngine)
SET(GEOM_GEOMSketcher GEOMSketcher)
SET(GEOM_SalomeIDLGEOM SalomeIDLGEOM)
SET(GEOM_SalomeIDLGEOMSuperv SalomeIDLGEOMSuperv)
SET(GEOM_SalomeIDLAdvancedGEOM SalomeIDLAdvancedGEOM)
SET(GEOM_SalomeIDLSTLPlugin SalomeIDLSTLPlugin)
SET(GEOM_SalomeIDLBREPPlugin SalomeIDLBREPPlugin)
SET(GEOM_SalomeIDLSTEPPlugin SalomeIDLSTEPPlugin)
SET(GEOM_SalomeIDLIGESPlugin SalomeIDLIGESPlugin)
SET(GEOM_SalomeIDLXAOPlugin SalomeIDLXAOPlugin)
SET(GEOM_SalomeIDLVTKPlugin SalomeIDLVTKPlugin)
SET(GEOM_ShHealOper ShHealOper)
SET(GEOM_XAO XAO)
SET(GEOM_AdvancedEngine AdvancedEngine)
SET(GEOM_AdvancedGUI AdvancedGUI)
SET(GEOM_BasicGUI BasicGUI)
SET(GEOM_BlocksGUI BlocksGUI)
SET(GEOM_BooleanGUI BooleanGUI)
SET(GEOM_BuildGUI BuildGUI)
SET(GEOM_DisplayGUI DisplayGUI)
SET(GEOM_DlgRef DlgRef)
SET(GEOM_EntityGUI EntityGUI)
SET(GEOM_GEOMBase GEOMBase)
SET(GEOM_GEOMFiltersSelection GEOMFiltersSelection)
SET(GEOM_GEOM GEOM)
SET(GEOM_GEOMToolsGUI GEOMToolsGUI)
SET(GEOM_DependencyTree DependencyTree)
SET(GEOM_GenerationGUI GenerationGUI)
SET(GEOM_GroupGUI GroupGUI)
SET(GEOM_Material Material)
SET(GEOM_MeasureGUI MeasureGUI)
SET(GEOM_GEOMObject GEOMObject)
SET(GEOM_OCC2VTK OCC2VTK)
SET(GEOM_OperationGUI OperationGUI)
SET(GEOM_PrimitiveGUI PrimitiveGUI)
SET(GEOM_RepairGUI RepairGUI)
SET(GEOM_TransformationGUI TransformationGUI)
SET(GEOM_STLPluginGUI STLPluginGUI)
SET(GEOM_STLPluginEngine STLPluginEngine)
SET(GEOM_BREPPluginGUI BREPPluginGUI)
SET(GEOM_BREPPluginEngine BREPPluginEngine)
SET(GEOM_STEPPluginGUI STEPPluginGUI)
SET(GEOM_STEPPluginEngine STEPPluginEngine)
SET(GEOM_IGESPluginGUI IGESPluginGUI)
SET(GEOM_IGESPluginEngine IGESPluginEngine)
SET(GEOM_XAOPluginGUI XAOPluginGUI)
SET(GEOM_XAOPluginEngine XAOPluginEngine)
SET(GEOM_VTKPluginGUI VTKPluginGUI)
SET(GEOM_VTKPluginEngine VTKPluginEngine)
SET(GEOM_GEOMShapeRec GEOMShapeRec)
SET(GEOM_CurveCreator CurveCreator)
