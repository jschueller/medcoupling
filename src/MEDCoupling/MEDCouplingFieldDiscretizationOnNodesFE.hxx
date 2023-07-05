// Copyright (C) 2022  CEA/DEN, EDF R&D
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
// Author : Anthony Geay (EDF R&D)

#pragma once

#include "MEDCouplingFieldDiscretization.hxx"

#include <functional>

namespace MEDCoupling
{
  /*!
   * Class in charge to implement FE functions with shape functions
   */
  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationOnNodesFE : public MEDCouplingFieldDiscretizationOnNodes
  {
    public:
      TypeOfField getEnum() const override { return TYPE; }
      std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationOnNodesFE"); }
      const char *getRepr() const override { return REPR; }
      std::string getStringRepr() const override;
      void reprQuickOverview(std::ostream& stream) const override;
      MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
      bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
      MEDCouplingFieldDiscretization *clone() const override;
      void checkCompatibilityWithNature(NatureOfField nat) const override;
      MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
      void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
      DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    public:
      MCAuto<DataArrayDouble> getCooInRefElement(const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const;
    public:
      static void GetRefCoordOfListOf3DPtsIn3D(const MEDCouplingUMesh *umesh, const double *ptsCoo, mcIdType nbOfPts,
  std::function<void(const MEDCouplingGaussLocalization&, const std::vector<mcIdType>&)> customFunc);
    private:
      const MEDCouplingUMesh *checkConfig3D(const MEDCouplingMesh *mesh) const;
    public:
      static const char REPR[];
      static constexpr TypeOfField TYPE = ON_NODES_FE;
  };
}
