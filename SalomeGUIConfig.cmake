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

# - Config file for the SalomeGUI package
# It defines the following variables. 
# Specific to the pacakge SalomeGUI itself:
#  SALOMEGUI_ROOT_DIR_EXP - the root path of the installation providing this CMake file
#

### Initialisation performed by CONFIGURE_PACKAGE_CONFIG_FILE:

####### Expanded from @PACKAGE_INIT@ by configure_package_config_file() #######
####### Any changes to this file will be overwritten by the next CMake run ####
####### The input file was SalomeGUIConfig.cmake.in                            ########

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

# Load the dependencies for the libraries of SalomeGUI 
# (contains definitions for IMPORTED targets). This is only 
# imported if we are not built as a subproject (in this case targets are already there)
IF(NOT TARGET Event AND NOT SalomeGUI_BINARY_DIR)
  INCLUDE("${PACKAGE_PREFIX_DIR}/adm_local/cmake_files/SalomeGUITargets.cmake")
ENDIF()   

# Package root dir:
SET_AND_CHECK(GUI_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}")

# Include directories
SET_AND_CHECK(GUI_INCLUDE_DIRS "${GUI_ROOT_DIR_EXP}/include/salome")
SET(GUI_INCLUDE_DIRS "${GUI_INCLUDE_DIRS};C:/work/SALOME-9.10.0/W64/Python/include;C:/work/SALOME-9.10.0/W64/pthreads/include;C:/work/SALOME-9.10.0/W64/EXT/include/boost-1_67;C:/work/SALOME-9.10.0/W64/EXT/include;C:/work/SALOME-9.10.0/W64/omniORB/include;C:/work/SALOME-9.10.0/W64/CAS/inc;C:/work/SALOME-9.10.0/W64/qt/include/;C:/work/SALOME-9.10.0/W64/qt/include/QtCore;C:/work/SALOME-9.10.0/W64/qt/.//mkspecs/win32-msvc;C:/work/SALOME-9.10.0/W64/qt/include/QtGui;C:/work/SALOME-9.10.0/W64/qt/include/QtWidgets;C:/work/SALOME-9.10.0/W64/qt/include/QtNetwork;C:/work/SALOME-9.10.0/W64/qt/include/QtXml;C:/work/SALOME-9.10.0/W64/qt/include/QtOpenGL;C:/work/SALOME-9.10.0/W64/qt/include/QtPrintSupport;C:/work/SALOME-9.10.0/W64/qt/include/QtHelp;C:/work/SALOME-9.10.0/W64/qt/include/QtSql;C:/work/SALOME-9.10.0/W64/qt/include/QtTest;C:/work/SALOME-9.10.0/W64/qwt/include")
SET(GUI_DEFINITIONS "")

# Package specific environment variables
SET(SalomeGUI_EXTRA_ENV LD_LIBRARY_PATH;PATH;PYTHONPATH;PV_PLUGIN_PATH)
SET(SalomeGUI_EXTRA_ENV_LD_LIBRARY_PATH C:/work/SALOME-9.10.0/W64/EXT/lib;C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/pthreads/lib;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/bin/x86_win32;C:/work/SALOME-9.10.0/W64/KERNEL/lib/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/lib;C:/work/SALOME-9.10.0/W64/CAS/win64/vc14/bin;C:/work/SALOME-9.10.0/W64/qt/bin;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;C:/work/SALOME-9.10.0/W64/qwt/lib;${PACKAGE_PREFIX_DIR}/lib/salome)
SET(SalomeGUI_EXTRA_ENV_PATH C:/work/SALOME-9.10.0/W64/Python;C:/work/SALOME-9.10.0/W64/swig/bin;C:/work/SALOME-9.10.0/W64/EXT/bin;C:/work/SALOME-9.10.0/W64/Python/Scripts;C:/work/SALOME-9.10.0/W64/sip/Scripts;C:/work/SALOME-9.10.0/W64/PyQt/bin)
SET(SalomeGUI_EXTRA_ENV_PYTHONPATH C:/work/SALOME-9.10.0/W64/Python/lib;C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32;C:/work/SALOME-9.10.0/W64/omniORB/lib/python;C:/work/SALOME-9.10.0/W64/Python/lib/site-packages;C:/work/SALOME-9.10.0/W64/KERNEL/bin/salome;C:/work/SALOME-9.10.0/W64/KERNEL/lib/python3.6/site-packages/salome;C:/work/SALOME-9.10.0/W64/sip/lib/site-packages;C:/work/SALOME-9.10.0/W64/PyQt;C:/work/SALOME-9.10.0/W64/PyQt/PyQt5;C:/work/SALOME-9.10.0/W64/ParaView/bin;${PACKAGE_PREFIX_DIR}/bin/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome;${PACKAGE_PREFIX_DIR}/lib/salome;${PACKAGE_PREFIX_DIR}/lib/python3.6/site-packages/salome/shared_modules)
SET(SalomeGUI_EXTRA_ENV_PV_PLUGIN_PATH C:/work/SALOME-9.10.0/W64/ParaView/bin)

#### Now the specificities

# Options exported by the package:
SET(SALOME_GUI_BUILD_DOC      ON)
SET(SALOME_GUI_BUILD_TESTS    ON)
SET(SALOME_GUI_LIGHT_ONLY     OFF)

# Advanced options
SET(SALOME_USE_OCCVIEWER      ON)
SET(SALOME_USE_GLVIEWER       ON)
SET(SALOME_USE_VTKVIEWER      ON)
SET(SALOME_USE_PLOT2DVIEWER   ON)
SET(SALOME_USE_GRAPHICSVIEW   ON)
SET(SALOME_USE_QXGRAPHVIEWER  ON)
SET(SALOME_USE_PVVIEWER       ON)
SET(SALOME_USE_PYVIEWER       ON)
SET(SALOME_USE_PYCONSOLE      ON)
SET(SALOME_USE_SALOMEOBJECT   ON)
SET(SALOME_GUI_USE_OBSERVERS  ON)
SET(SALOME_GUI_USE_OPENGL2    TRUE)
SET(SALOME_ON_DEMAND          OFF)

IF(SALOME_ON_DEMAND)
  LIST(APPEND GUI_DEFINITIONS "-DWITH_SALOME_ON_DEMAND")
ENDIF()
IF(SALOME_GUI_LIGHT_ONLY)
  LIST(APPEND GUI_DEFINITIONS "-DGUI_DISABLE_CORBA")
ENDIF() 
IF(SALOME_GUI_USE_OBSERVERS)
  LIST(APPEND GUI_DEFINITIONS "-DWITH_SALOMEDS_OBSERVER")
ENDIF()
IF(NOT SALOME_USE_OCCVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_OCCVIEWER")
ENDIF()
IF(NOT SALOME_USE_GLVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_GLVIEWER")
ENDIF()

IF(NOT SALOME_USE_VTKVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_VTKVIEWER")
ELSE()
  IF(SALOME_GUI_USE_OPENGL2)
    LIST(APPEND GUI_DEFINITIONS "-DVTK_OPENGL2")
  ENDIF()
ENDIF()
IF(NOT SALOME_USE_PLOT2DVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_PLOT2DVIEWER")
ENDIF()
IF (NOT SALOME_USE_GRAPHICSVIEW)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_GRAPHICSVIEW")
ENDIF()
IF (NOT SALOME_USE_PVVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_PVVIEWER")
ENDIF()
IF(NOT SALOME_USE_PYVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_PYVIEWER")
ENDIF()
IF(NOT SALOME_USE_PYCONSOLE)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_PYCONSOLE")
ENDIF()
IF(NOT SALOME_USE_QXGRAPHVIEWER)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_QXGRAPHVIEWER")
ENDIF()
IF(NOT SALOME_USE_SALOMEOBJECT)
  LIST(APPEND GUI_DEFINITIONS "-DDISABLE_SALOMEOBJECT")
ENDIF()

# Level 1 prerequisites:
SET_AND_CHECK(KERNEL_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/KERNEL")
SET_AND_CHECK(SIP_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/sip")
SET_AND_CHECK(QT5_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}/")
SET_AND_CHECK(PYQT5_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/PyQt")
SET_AND_CHECK(OPENCASCADE_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/CAS")

# Optional level 1 prerequisites:
IF(SALOME_USE_GLVIEWER)
  SET_AND_CHECK(OPENGL_ROOT_DIR_EXP "${PACKAGE_PREFIX_DIR}/") 
ENDIF()
IF(SALOME_USE_VTKVIEWER)
  SET_AND_CHECK(VTK_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/ParaView")
ENDIF()
IF(SALOME_USE_PLOT2DVIEWER)
  SET_AND_CHECK(QWT_ROOT_DIR_EXP "C:/work/SALOME-9.10.0/W64/qwt")
ENDIF()

# For all prerequisites, load the corresponding targets if the package was used
# in CONFIG mode. This ensures dependent projects link correctly
# without having to set LD_LIBRARY_PATH:
SET(_PREREQ_SalomeGUI  OpenCASCADE Qt5 ParaView VTK)
SET(_PREREQ_SalomeGUI_CONFIG_DIR  "C:/work/SALOME-9.10.0/W64/CAS/cmake" "C:/work/SALOME-9.10.0/W64/qt/lib/cmake/Qt5" "C:/work/SALOME-9.10.0/W64/ParaView/lib/cmake/paraview-5.11" "C:/work/SALOME-9.10.0/W64/ParaView/lib/cmake/paraview-5.11/vtk")
SET(_PREREQ_SalomeGUI_COMPONENTS ";Gui,Widgets,Network,Xml,OpenGL,PrintSupport,Help,Test;;RenderingLOD,RenderingAnnotation,FiltersParallel,IOExport,WrappingPythonCore,IOXML,FiltersVerdict,RenderingLabel,InteractionWidgets,InfovisCore,InteractionStyle,CommonSystem;")
LIST(LENGTH _PREREQ_SalomeGUI_CONFIG_DIR _list_len_SalomeGUI)
IF(NOT _list_len_SalomeGUI EQUAL 0)
  # Another CMake stupidity - FOREACH(... RANGE r) generates r+1 numbers ...
  MATH(EXPR _range_SalomeGUI "${_list_len_SalomeGUI}-1")
  FOREACH(_p_SalomeGUI RANGE ${_range_SalomeGUI})
    LIST(GET _PREREQ_SalomeGUI            ${_p_SalomeGUI} _pkg_SalomeGUI    )
    LIST(GET _PREREQ_SalomeGUI_CONFIG_DIR ${_p_SalomeGUI} _pkg_dir_SalomeGUI)
    LIST(GET _PREREQ_SalomeGUI_COMPONENTS ${_p_SalomeGUI} _pkg_compo_SalomeGUI)
    IF(NOT OMIT_DETECT_PACKAGE_${_pkg_SalomeGUI})
      MESSAGE(STATUS "===> Reloading targets from ${_pkg_SalomeGUI} ...")
      IF(NOT _pkg_compo_SalomeGUI)
        FIND_PACKAGE(${_pkg_SalomeGUI} REQUIRED NO_MODULE
            PATHS "${_pkg_dir_SalomeGUI}"
            NO_DEFAULT_PATH)
      ELSE()
        STRING(REPLACE "," ";" _compo_lst_SalomeGUI "${_pkg_compo_SalomeGUI}")
        MESSAGE(STATUS "===> (components: ${_pkg_compo_SalomeGUI})")
        FIND_PACKAGE(${_pkg_SalomeGUI} REQUIRED NO_MODULE
            COMPONENTS ${_compo_lst_SalomeGUI}
            PATHS "${_pkg_dir_SalomeGUI}"
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
SET(SALOME_INSTALL_AMCONFIG_LOCAL "adm_local/unix")

# Include KERNEL targets if they were not already loaded:
IF(NOT (TARGET SALOMEBasics)) 
  INCLUDE("${KERNEL_ROOT_DIR_EXP}/${SALOME_INSTALL_CMAKE}/SalomeKERNELTargets.cmake")
ENDIF()

# Exposed GUI targets:
SET(GUI_caf caf)
SET(GUI_CAM CAM)
SET(GUI_CASCatch CASCatch)
SET(GUI_DDS DDS)
SET(GUI_Event Event)
SET(GUI_GLViewer GLViewer)
SET(GUI_LightApp LightApp)
SET(GUI_LogWindow LogWindow)
SET(GUI_ObjBrowser ObjBrowser)
SET(GUI_OCCViewer OCCViewer)
SET(GUI_OpenGLUtils OpenGLUtils)
SET(GUI_Plot2d Plot2d)
SET(GUI_PyConsole PyConsole)
SET(GUI_PyInterp PyInterp)
SET(GUI_PyEditor PyEditor)
SET(GUI_PyViewer PyViewer)
SET(GUI_QDS QDS)
SET(GUI_qtx qtx)
SET(GUI_QxScene QxScene)
SET(GUI_SalomeApp SalomeApp)
SET(GUI_SalomeAppSL SalomeAppSL)
SET(GUI_SalomeAppImpl SalomeAppImpl)
SET(GUI_SalomeIDLGUI SalomeIDLGUI)
SET(GUI_SalomeObject SalomeObject)
SET(GUI_SalomePrs SalomePrs)
SET(GUI_SalomePyQtGUILight SalomePyQtGUILight)
SET(GUI_SalomePyQtGUI SalomePyQtGUI)
SET(GUI_SalomePyQt SalomePyQt)
SET(GUI_SalomePy SalomePy)
SET(GUI_SalomeSession SalomeSession)
SET(GUI_SalomeStyle SalomeStyle)
SET(GUI_SOCC SOCC)
SET(GUI_SPlot2d SPlot2d)
SET(GUI_std std)
SET(GUI_SUITApp SUITApp)
SET(GUI_suit suit)
SET(GUI_SVTK SVTK)
SET(GUI_ToolsGUI ToolsGUI)
SET(GUI_ViewerTools ViewerTools)
SET(GUI_ViewerData ViewerData)
SET(GUI_VTKViewer VTKViewer)
SET(GUI_PVViewer PVViewer)
SET(GUI_PVServerService PVServerService)
SET(GUI_vtkTools vtkTools)
SET(GUI_SalomeGuiHelpers SalomeGuiHelpers)
SET(GUI_SalomeTreeData SalomeTreeData)
SET(GUI_ImageComposer ImageComposer)
SET(GUI_GraphicsView GraphicsView)
