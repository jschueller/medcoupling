// Copyright (C) 2007-2022  CEA/DEN, EDF R&D
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
//
// See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
//
// Author : Anthony Geay (CEA/DEN)

#ifndef __CELLMODEL_INTERP_KERNEL_HXX__
#define __CELLMODEL_INTERP_KERNEL_HXX__

#include "INTERPKERNELDefines.hxx"

#include "NormalizedUnstructuredMesh.hxx"
#include "MCIdType.hxx"

#include <map>

constexpr int MEDCOUPLING2VTKTYPETRADUCER_LGTH=INTERP_KERNEL::NORM_MAXTYPE+1;

constexpr unsigned char MEDCOUPLING2VTKTYPETRADUCER_NONE = 255;

INTERPKERNEL_EXPORT extern unsigned char MEDCOUPLING2VTKTYPETRADUCER[MEDCOUPLING2VTKTYPETRADUCER_LGTH];

namespace INTERP_KERNEL
{
  class DiameterCalculator;
  class OrientationInverter;

  /*!
   * This class describes all static elements (different from polygons and polyhedron) 3D, 2D and 1D.
   */
  class INTERPKERNEL_EXPORT CellModel
  {
  public:
    static const unsigned MAX_NB_OF_SONS=8;
    static const unsigned MAX_NB_OF_NODES_PER_ELEM=30;
    static const unsigned MAX_NB_OF_LITTLE_SONS=12;
  private:
    CellModel(NormalizedCellType type);
    static void BuildUniqueInstance(std::map<NormalizedCellType,CellModel>& map);
  public:
    static const CellModel& GetCellModel(NormalizedCellType type);
    static const std::map<NormalizedCellType,CellModel>& GetMapOfUniqueInstance();
    NormalizedCellType getEnum() const { return _type; }
    const char *getRepr() const;
    bool isExtruded() const { return _is_extruded; }
    bool isDynamic() const { return _dyn; }
    bool isQuadratic() const { return _quadratic; }
    unsigned getDimension() const { return _dim; }
    bool isCompatibleWith(NormalizedCellType type) const;
    bool isSimplex() const { return _is_simplex; }
    //! sonId is in C format.
    const unsigned *getNodesConstituentTheSon(unsigned sonId) const { return _sons_con[sonId]; }
    const unsigned *getNodesConstituentTheLittleSon(unsigned littleSonId) const { return _little_sons_con[littleSonId]; }
    bool getOrientationStatus(mcIdType lgth, const mcIdType *conn1, const mcIdType *conn2) const;
    unsigned getNumberOfNodes() const { return _nb_of_pts; }
    unsigned getNumberOfSons() const { return _nb_of_sons; }
    unsigned getNumberOfSons2(const mcIdType *conn, mcIdType lgth) const;
    unsigned getNumberOfEdgesIn3D(const mcIdType *conn, mcIdType lgth) const;
    unsigned getNumberOfMicroEdges() const;
    unsigned getNumberOfNodesConstituentTheSon(unsigned sonId) const { return _nb_of_sons_con[sonId]; }
    unsigned getNumberOfNodesConstituentTheSon2(unsigned sonId, const mcIdType *nodalConn, mcIdType lgth) const;
    NormalizedCellType getExtrudedType() const { return _extruded_type; }
    NormalizedCellType getCorrespondingPolyType() const;
    NormalizedCellType getReverseExtrudedType() const { return _reverse_extruded_type; }
    NormalizedCellType getLinearType() const { return _linear_type; }
    NormalizedCellType getQuadraticType() const { return _quadratic_type; }
    NormalizedCellType getQuadraticType2() const { return _quadratic_type2; }
    NormalizedCellType getSonType(unsigned sonId) const { return _sons_type[sonId]; }
    NormalizedCellType getSonType2(unsigned sonId) const;
    unsigned fillSonCellNodalConnectivity(int sonId, const mcIdType *nodalConn, mcIdType *sonNodalConn) const;
    unsigned fillSonCellNodalConnectivity2(int sonId, const mcIdType *nodalConn, mcIdType lgth, mcIdType *sonNodalConn, NormalizedCellType& typeOfSon) const;
    unsigned fillSonCellNodalConnectivity4(int sonId, const mcIdType *nodalConn, mcIdType lgth, mcIdType *sonNodalConn, NormalizedCellType& typeOfSon) const;
    unsigned fillSonEdgesNodalConnectivity3D(int sonId, const mcIdType *nodalConn, mcIdType lgth, mcIdType *sonNodalConn, NormalizedCellType& typeOfSon) const;
    unsigned fillMicroEdgeNodalConnectivity(int sonId, const mcIdType *nodalConn, mcIdType *sonNodalConn, NormalizedCellType& typeOfSon) const;
    void changeOrientationOf2D(mcIdType *nodalConn, unsigned int sz) const;
    void changeOrientationOf1D(mcIdType *nodalConn, unsigned int sz) const;
    DiameterCalculator *buildInstanceOfDiameterCalulator(int spaceDim) const;
    OrientationInverter *buildOrientationInverter() const;
  private:
    bool _dyn;
    bool _quadratic;
    bool _is_simplex;
    bool _is_extruded;
    unsigned _dim;
    unsigned _nb_of_pts;
    unsigned _nb_of_sons;
    unsigned _nb_of_little_sons;
    NormalizedCellType _type;
    NormalizedCellType _extruded_type;
    NormalizedCellType _reverse_extruded_type;
    NormalizedCellType _linear_type;
    NormalizedCellType _quadratic_type;
    NormalizedCellType _quadratic_type2;
    unsigned _sons_con[MAX_NB_OF_SONS][MAX_NB_OF_NODES_PER_ELEM];
    unsigned _little_sons_con[MAX_NB_OF_LITTLE_SONS][3];
    unsigned _nb_of_sons_con[MAX_NB_OF_SONS];
    NormalizedCellType _sons_type[MAX_NB_OF_SONS];
    static const char *CELL_TYPES_REPR[];
  };
}

#endif
