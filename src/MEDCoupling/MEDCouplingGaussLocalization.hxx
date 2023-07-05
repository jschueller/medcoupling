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

#ifndef __PARAMEDMEM_MEDCOUPLINGGAUSSLOCALIZATION_HXX__
#define __PARAMEDMEM_MEDCOUPLINGGAUSSLOCALIZATION_HXX__

#include "MEDCoupling.hxx"
#include "NormalizedUnstructuredMesh.hxx"
#include "MEDCouplingMemArray.hxx"
#include "InterpKernelException.hxx"

#include <vector>

namespace MEDCoupling
{
  class MEDCouplingMesh;
  class MEDCouplingUMesh;

  class MEDCOUPLING_EXPORT MEDCouplingGaussLocalization
  {
  public:
    MEDCouplingGaussLocalization(INTERP_KERNEL::NormalizedCellType type, const std::vector<double>& refCoo,
                                                    const std::vector<double>& gsCoo, const std::vector<double>& w);
    MEDCouplingGaussLocalization(INTERP_KERNEL::NormalizedCellType typ);
    INTERP_KERNEL::NormalizedCellType getType() const { return _type; }
    void setType(INTERP_KERNEL::NormalizedCellType typ);
    int getNumberOfGaussPt() const { return (int)_weight.size(); }
    int getDimension() const;
    int getNumberOfPtsInRefCell() const;
    std::string getStringRepr() const;
    std::size_t getMemorySize() const;
    void checkConsistencyLight() const;
    bool isEqual(const MEDCouplingGaussLocalization& other, double eps) const;
    void pushTinySerializationIntInfo(std::vector<mcIdType>& tinyInfo) const;
    void pushTinySerializationDblInfo(std::vector<double>& tinyInfo) const;
    const double *fillWithValues(const double *vals);
    //
    MCAuto<DataArrayDouble> localizePtsInRefCooForEachCell(const DataArrayDouble *ptsInRefCoo, const MEDCouplingUMesh *mesh) const;
    MCAuto<MEDCouplingUMesh> buildRefCell() const;
    MCAuto<DataArrayDouble> getShapeFunctionValues() const;
    MCAuto<DataArrayDouble> getDerivativeOfShapeFunctionValues() const;
    //
    const std::vector<double>& getRefCoords() const { return _ref_coord; }
    double getRefCoord(int ptIdInCell, int comp) const;
    const std::vector<double>& getGaussCoords() const { return _gauss_coord; }
    double getGaussCoord(int gaussPtIdInCell, int comp) const;
    const std::vector<double>& getWeights() const { return _weight; }
    double getWeight(int gaussPtIdInCell) const;
    void setRefCoord(int ptIdInCell, int comp, double newVal);
    void setGaussCoord(int gaussPtIdInCell, int comp, double newVal);
    void setWeight(int gaussPtIdInCell, double newVal);
    void setRefCoords(const std::vector<double>& refCoo);
    void setGaussCoords(const std::vector<double>& gsCoo);
    void setWeights(const std::vector<double>& w);
    //
    static MEDCouplingGaussLocalization BuildNewInstanceFromTinyInfo(mcIdType dim, const std::vector<mcIdType>& tinyData);
    static bool AreAlmostEqual(const std::vector<double>& v1, const std::vector<double>& v2, double eps);
    static MCAuto<DataArrayDouble> GetDefaultReferenceCoordinatesOf(INTERP_KERNEL::NormalizedCellType type);
  private:
    int checkCoherencyOfRequest(mcIdType gaussPtIdInCell, int comp) const;
  private:
    INTERP_KERNEL::NormalizedCellType _type;
    std::vector<double> _ref_coord;
    std::vector<double> _gauss_coord;
    std::vector<double> _weight;
  };
}

#endif
