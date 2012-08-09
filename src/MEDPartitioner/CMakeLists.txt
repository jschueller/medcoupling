# Copyright (C) 2007-2012  CEA/DEN, EDF R&D
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License.
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

ADD_SUBDIRECTORY(Test)

INCLUDE_DIRECTORIES(
  ${PARMETIS_INCLUDE_DIRS}
  ${METIS_INCLUDE_DIRS}
  ${SCOTCH_INCLUDE_DIRS}
  ${BOOST_INCLUDE_DIRS}
  ${METIS_INCLUDE_DIRS}
  ${LIBXML_INCLUDE_DIRS}
  ${MED3_INCLUDE_DIRS}
  ${HDF5_INCLUDE_DIRS}
  ${MPI_INCLUDE_DIRS}
  ${CMAKE_CURRENT_SOURCE_DIR}/../MEDLoader
  ${CMAKE_CURRENT_SOURCE_DIR}/../MEDCoupling
  ${CMAKE_CURRENT_SOURCE_DIR}/../INTERP_KERNEL
  ${CMAKE_CURRENT_SOURCE_DIR}/../INTERP_KERNEL/Bases
  ${CMAKE_CURRENT_SOURCE_DIR}/../INTERP_KERNEL/Geometric2D
  ${CMAKE_CURRENT_SOURCE_DIR}/../INTERP_KERNEL/ExprEval
  ${CMAKE_CURRENT_SOURCE_DIR}/../INTERP_KERNEL/GaussPoints
  )

SET(medpartitionercpp_HEADERS_HXX
  MEDPARTITIONER_MeshCollection.hxx
  MEDPARTITIONER_MeshCollectionDriver.hxx
  MEDPARTITIONER_MeshCollectionMedXmlDriver.hxx
  MEDPARTITIONER_MeshCollectionMedAsciiDriver.hxx
  MEDPARTITIONER_ParallelTopology.hxx
  MEDPARTITIONER_JointFinder.hxx
  MEDPARTITIONER_Graph.hxx
  MEDPARTITIONER_UserGraph.hxx
  MEDPARTITIONER_Utils.hxx
  MEDPARTITIONER.hxx
  MEDPARTITIONER_ParaDomainSelector.hxx
  MEDPARTITIONER_ConnectZone.hxx
  MEDPARTITIONER_SkyLineArray.hxx
  MEDPARTITIONER_Topology.hxx
  )

SET(medpartitionercpp_SOURCES
  MEDPARTITIONER_MeshCollection.cxx
  MEDPARTITIONER_MeshCollectionDriver.cxx
  MEDPARTITIONER_MeshCollectionMedXmlDriver.cxx
  MEDPARTITIONER_MeshCollectionMedAsciiDriver.cxx
  MEDPARTITIONER_ParallelTopology.cxx
  MEDPARTITIONER_Graph.cxx
  MEDPARTITIONER_UserGraph.cxx
  MEDPARTITIONER_Utils.cxx
  MEDPARTITIONER_ParaDomainSelector.cxx
  MEDPARTITIONER_ConnectZone.cxx
  MEDPARTITIONER_SkyLineArray.cxx
  )

SET(medpartitionercpp_DEFINITIONS "${HDF5_DEFINITIONS} ${MED3_DEFINITIONS} ${BOOST_DEFINITIONS} ${LIBXML_DEFINITIONS}")
SET(medpartitionercpp_LDFLAGS medloader ${LIBXML_LIBS})

IF(MED_ENABLE_SCOTCH)
  SET(medpartitionercpp_SOURCES ${medpartitionercpp_SOURCES} MEDPARTITIONER_ScotchGraph.cxx)
  SET(medpartitionercpp_HEADERS_HXX ${medpartitionercpp_HEADERS_HXX} MEDPARTITIONER_ScotchGraph.hxx)
  SET(medpartitionercpp_DEFINITIONS "${medpartitionercpp_DEFINITIONS} ${SCOTCH_DEFINITIONS}")
  SET(medpartitionercpp_LDFLAGS ${medpartitionercpp_LDFLAGS} ${SCOTCH_LIBS})
ENDIF(MED_ENABLE_SCOTCH)

IF(MPI_IS_OK)
  IF(MED_ENABLE_PARMETIS)
    SET(medpartitionercpp_SOURCES ${medpartitionercpp_SOURCES} MEDPARTITIONER_ParMetisGraph.cxx
      MEDPARTITIONER_UtilsPara.cxx
      MEDPARTITIONER_JointFinder.cxx
      )
    SET(medpartitionercpp_HEADERS_HXX ${medpartitionercpp_HEADERS_HXX} MEDPARTITIONER_JointFinder.hxx MEDPARTITIONER_MetisGraph.hxx)
    SET(medpartitionercpp_DEFINITIONS "${medpartitionercpp_DEFINITIONS} ${MPI_DEFINITIONS} ${PARMETIS_DEFINITIONS}")
    SET(medpartitionercpp_LDFLAGS ${medpartitionercpp_LDFLAGS} ${PARMETIS_LIBS} ${MPI_LIBS})
  ELSE(MED_ENABLE_PARMETIS)
    SET(medpartitionercpp_SOURCES ${medpartitionercpp_SOURCES}
      MEDPARTITIONER_UtilsPara.cxx
      MEDPARTITIONER_JointFinder.cxx
      )
    SET(medpartitionercpp_DEFINITIONS "${medpartitionercpp_DEFINITIONS} ${MPI_DEFINITIONS}")
    SET(medpartitionercpp_LDFLAGS ${medpartitionercpp_LDFLAGS} ${MPI_LIBS})
  ENDIF(MED_ENABLE_PARMETIS)
ELSE(MPI_IS_OK)
  IF(MED_ENABLE_METIS)
    SET(medpartitionercpp_SOURCES ${medpartitionercpp_SOURCES} MEDPARTITIONER_MetisGraph.cxx)
    SET(medpartitionercpp_HEADERS_HXX ${medpartitionercpp_HEADERS_HXX} MEDPARTITIONER_MetisGraph.hxx)
    SET(medpartitionercpp_DEFINITIONS "${medpartitionercpp_DEFINITIONS} ${METIS_DEFINITIONS}")
    SET(medpartitionercpp_LDFLAGS ${medpartitionercpp_LDFLAGS} ${METIS_LIBS})
  ENDIF(MED_ENABLE_METIS)
ENDIF(MPI_IS_OK)


IF(MPI_IS_OK)
  ADD_EXECUTABLE(medpartitioner_para medpartitioner_para.cxx)
  SET_TARGET_PROPERTIES(medpartitioner_para PROPERTIES COMPILE_FLAGS "${medpartitionercpp_DEFINITIONS}")
  TARGET_LINK_LIBRARIES(medpartitioner_para medpartitionercpp)
  INSTALL(TARGETS medpartitioner_para DESTINATION ${MED_salomebin_BINS})
ELSE(MPI_IS_OK)
  ADD_EXECUTABLE(medpartitioner medpartitioner.cxx)
  SET_TARGET_PROPERTIES(medpartitioner PROPERTIES COMPILE_FLAGS "${medpartitionercpp_DEFINITIONS}")
  TARGET_LINK_LIBRARIES(medpartitioner medpartitionercpp)
  INSTALL(TARGETS medpartitioner DESTINATION ${MED_salomebin_BINS})
ENDIF(MPI_IS_OK)

ADD_LIBRARY(medpartitionercpp SHARED ${medpartitionercpp_SOURCES})
SET_TARGET_PROPERTIES(medpartitionercpp PROPERTIES COMPILE_FLAGS "${medpartitionercpp_DEFINITIONS}")
TARGET_LINK_LIBRARIES(medpartitionercpp ${medpartitionercpp_LDFLAGS})
INSTALL(TARGETS medpartitionercpp DESTINATION ${MED_salomelib_LIBS})

INSTALL(FILES ${medpartitionercpp_HEADERS_HXX} DESTINATION ${MED_salomeinclude_HEADERS})