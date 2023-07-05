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

#ifndef __PARAMEDMEM_MEDCOUPLINGFIELDDISCRETIZATION_HXX__
#define __PARAMEDMEM_MEDCOUPLINGFIELDDISCRETIZATION_HXX__

#include "MEDCoupling.hxx"
#include "MEDCouplingRefCountObject.hxx"
#include "InterpKernelException.hxx"
#include "MEDCouplingTimeLabel.hxx"
#include "MEDCouplingNatureOfField.hxx"
#include "MEDCouplingGaussLocalization.hxx"
#include "MCAuto.hxx"

#include <set>
#include <vector>

namespace MEDCoupling
{
  class DataArray;
  class DataArrayIdType;
  class MEDCouplingMesh;
  class DataArrayDouble;
  class MEDCouplingFieldDouble;

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretization : public RefCountObject, public TimeLabel
  {
  public:
    static MEDCouplingFieldDiscretization *New(TypeOfField type);
    double getPrecision() const { return _precision; }
    void setPrecision(double val) { _precision=val; }
    void updateTime() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    static TypeOfField GetTypeOfFieldFromStringRepr(const std::string& repr);
    static std::string GetTypeOfFieldRepr(TypeOfField type);
    virtual TypeOfField getEnum() const = 0;
    virtual bool isEqual(const MEDCouplingFieldDiscretization *other, double eps) const;
    virtual bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const = 0;
    virtual bool isEqualWithoutConsideringStr(const MEDCouplingFieldDiscretization *other, double eps) const;
    virtual MEDCouplingFieldDiscretization *deepCopy() const;
    virtual MEDCouplingFieldDiscretization *clone() const = 0;
    virtual MEDCouplingFieldDiscretization *clonePart(const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    virtual MEDCouplingFieldDiscretization *clonePartRange(mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds) const;
    virtual std::string getStringRepr() const = 0;
    virtual const char *getRepr() const = 0;
    virtual mcIdType getNumberOfTuplesExpectedRegardingCode(const std::vector<mcIdType>& code, const std::vector<const DataArrayIdType *>& idsPerType) const = 0;
    virtual mcIdType getNumberOfTuples(const MEDCouplingMesh *mesh) const = 0;
    virtual mcIdType getNumberOfMeshPlaces(const MEDCouplingMesh *mesh) const = 0;
    virtual DataArrayIdType *getOffsetArr(const MEDCouplingMesh *mesh) const = 0;
    virtual void normL1(const MEDCouplingMesh *mesh, const DataArrayDouble *arr, double *res) const;
    virtual void normL2(const MEDCouplingMesh *mesh, const DataArrayDouble *arr, double *res) const;
    virtual void integral(const MEDCouplingMesh *mesh, const DataArrayDouble *arr, bool isWAbs, double *res) const;
    virtual DataArrayDouble *getLocalizationOfDiscValues(const MEDCouplingMesh *mesh) const = 0;
    virtual void computeMeshRestrictionFromTupleIds(const MEDCouplingMesh *mesh, const mcIdType *tupleIdsBg, const mcIdType *tupleIdsEnd,
                                                                       DataArrayIdType *&cellRestriction, DataArrayIdType *&trueTupleRestriction) const = 0;
    virtual void checkCompatibilityWithNature(NatureOfField nat) const = 0;
    virtual void renumberCells(const mcIdType *old2NewBg, bool check=true);
    virtual void renumberArraysForCell(const MEDCouplingMesh *mesh, const std::vector<DataArray *>& arrays,
                                                          const mcIdType *old2NewBg, bool check) = 0;
    virtual double getIJK(const MEDCouplingMesh *mesh, const DataArrayDouble *da, mcIdType cellId, mcIdType nodeIdInCell, int compoId) const;
    virtual void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const = 0;
    virtual MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const = 0;
    virtual void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const = 0;
    virtual void getValueOnPos(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, mcIdType i, mcIdType j, mcIdType k, double *res) const = 0;
    virtual DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const = 0;
    virtual DataArrayIdType *computeTupleIdsToSelectFromCellIds(const MEDCouplingMesh *mesh, const mcIdType *startCellIds, const mcIdType *endCellIds) const = 0;
    virtual MEDCouplingMesh *buildSubMeshData(const MEDCouplingMesh *mesh, const mcIdType *start, const mcIdType *end, DataArrayIdType *&di) const = 0;
    virtual MEDCouplingMesh *buildSubMeshDataRange(const MEDCouplingMesh *mesh, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds, mcIdType& beginOut, mcIdType& endOut, mcIdType& stepOut, DataArrayIdType *&di) const;
    virtual void renumberValuesOnNodes(double epsOnVals, const mcIdType *old2New, mcIdType newNbOfNodes, DataArrayDouble *arr) const = 0;
    virtual void renumberValuesOnCells(double epsOnVals, const MEDCouplingMesh *mesh, const mcIdType *old2New, mcIdType newSz, DataArrayDouble *arr) const = 0;
    virtual void renumberValuesOnCellsR(const MEDCouplingMesh *mesh, const mcIdType *new2old, mcIdType newSz, DataArrayDouble *arr) const = 0;
    virtual MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const = 0;
    virtual void getSerializationIntArray(DataArrayIdType *& arr) const;
    virtual void getTinySerializationIntInformation(std::vector<mcIdType>& tinyInfo) const;
    virtual void getTinySerializationDbleInformation(std::vector<double>& tinyInfo) const;
    virtual void finishUnserialization(const std::vector<double>& tinyInfo);
    virtual void resizeForUnserialization(const std::vector<mcIdType>& tinyInfo, DataArrayIdType *& arr);
    virtual void checkForUnserialization(const std::vector<mcIdType>& tinyInfo, const DataArrayIdType *arr);
    virtual void setGaussLocalizationOnType(const MEDCouplingMesh *m, INTERP_KERNEL::NormalizedCellType type, const std::vector<double>& refCoo,
                                                               const std::vector<double>& gsCoo, const std::vector<double>& wg);
    virtual void setGaussLocalizationOnCells(const MEDCouplingMesh *m, const mcIdType *begin, const mcIdType *end, const std::vector<double>& refCoo,
                                                                const std::vector<double>& gsCoo, const std::vector<double>& wg);
    virtual void clearGaussLocalizations();
    virtual MEDCouplingGaussLocalization& getGaussLocalization(mcIdType locId);
    virtual mcIdType getNbOfGaussLocalization() const;
    virtual mcIdType getGaussLocalizationIdOfOneCell(mcIdType cellId) const;
    virtual mcIdType getGaussLocalizationIdOfOneType(INTERP_KERNEL::NormalizedCellType type) const;
    virtual std::set<mcIdType> getGaussLocalizationIdsOfOneType(INTERP_KERNEL::NormalizedCellType type) const;
    virtual void getCellIdsHavingGaussLocalization(mcIdType locId, std::vector<mcIdType>& cellIds) const;
    virtual const MEDCouplingGaussLocalization& getGaussLocalization(mcIdType locId) const;
    virtual void reprQuickOverview(std::ostream& stream) const = 0;
    virtual ~MEDCouplingFieldDiscretization();
  protected:
    MEDCouplingFieldDiscretization();
    static void RenumberEntitiesFromO2NArr(double epsOnVals, const mcIdType *old2NewPtr, mcIdType newNbOfEntity, DataArrayDouble *arr, const std::string& msg);
    static void RenumberEntitiesFromN2OArr(const mcIdType *new2OldPtr, mcIdType new2OldSz, DataArrayDouble *arr, const std::string& msg);
    template<class FIELD_DISC>
    static MCAuto<MEDCouplingFieldDiscretization> EasyAggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds);
  protected:
    double _precision;
    static const double DFLT_PRECISION;
  };

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationP0 : public MEDCouplingFieldDiscretization
  {
  public:
    TypeOfField getEnum() const;
    std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationP0"); }
    MEDCouplingFieldDiscretization *clone() const override;
    std::string getStringRepr() const;
    const char *getRepr() const;
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    mcIdType getNumberOfTuplesExpectedRegardingCode(const std::vector<mcIdType>& code, const std::vector<const DataArrayIdType *>& idsPerType) const;
    mcIdType getNumberOfTuples(const MEDCouplingMesh *mesh) const;
    mcIdType getNumberOfMeshPlaces(const MEDCouplingMesh *mesh) const;
    DataArrayIdType *getOffsetArr(const MEDCouplingMesh *mesh) const;
    void renumberArraysForCell(const MEDCouplingMesh *mesh, const std::vector<DataArray *>& arrays,
                                                  const mcIdType *old2NewBg, bool check);
    DataArrayDouble *getLocalizationOfDiscValues(const MEDCouplingMesh *mesh) const;
    void checkCompatibilityWithNature(NatureOfField nat) const override;
    void computeMeshRestrictionFromTupleIds(const MEDCouplingMesh *mesh, const mcIdType *tupleIdsBg, const mcIdType *tupleIdsEnd,
                                                               DataArrayIdType *&cellRestriction, DataArrayIdType *&trueTupleRestriction) const;
    void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const;
    MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
    void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
    void getValueOnPos(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, mcIdType i, mcIdType j, mcIdType k, double *res) const;
    DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    void renumberValuesOnNodes(double epsOnVals, const mcIdType *old2New, mcIdType newNbOfNodes, DataArrayDouble *arr) const;
    void renumberValuesOnCells(double epsOnVals, const MEDCouplingMesh *mesh, const mcIdType *old2New, mcIdType newSz, DataArrayDouble *arr) const;
    void renumberValuesOnCellsR(const MEDCouplingMesh *mesh, const mcIdType *new2old, mcIdType newSz, DataArrayDouble *arr) const;
    MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
    MEDCouplingMesh *buildSubMeshData(const MEDCouplingMesh *mesh, const mcIdType *start, const mcIdType *end, DataArrayIdType *&di) const;
    MEDCouplingMesh *buildSubMeshDataRange(const MEDCouplingMesh *mesh, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds, mcIdType& beginOut, mcIdType& endOut, mcIdType& stepOut, DataArrayIdType *&di) const;
    DataArrayIdType *computeTupleIdsToSelectFromCellIds(const MEDCouplingMesh *mesh, const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    void reprQuickOverview(std::ostream& stream) const;
  public:
    static const char REPR[];
    static constexpr TypeOfField TYPE = ON_CELLS;
  };

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationOnNodes : public MEDCouplingFieldDiscretization
  {
  public:
    mcIdType getNumberOfTuples(const MEDCouplingMesh *mesh) const;
    mcIdType getNumberOfTuplesExpectedRegardingCode(const std::vector<mcIdType>& code, const std::vector<const DataArrayIdType *>& idsPerType) const;
    mcIdType getNumberOfMeshPlaces(const MEDCouplingMesh *mesh) const;
    DataArrayIdType *getOffsetArr(const MEDCouplingMesh *mesh) const;
    void renumberArraysForCell(const MEDCouplingMesh *mesh, const std::vector<DataArray *>& arrays,
                                                  const mcIdType *old2NewBg, bool check);
    DataArrayDouble *getLocalizationOfDiscValues(const MEDCouplingMesh *mesh) const;
    void computeMeshRestrictionFromTupleIds(const MEDCouplingMesh *mesh, const mcIdType *tupleIdsBg, const mcIdType *tupleIdsEnd,
                                                               DataArrayIdType *&cellRestriction, DataArrayIdType *&trueTupleRestriction) const;
    void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const;
    MEDCouplingMesh *buildSubMeshData(const MEDCouplingMesh *mesh, const mcIdType *start, const mcIdType *end, DataArrayIdType *&di) const;
    MEDCouplingMesh *buildSubMeshDataRange(const MEDCouplingMesh *mesh, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds, mcIdType& beginOut, mcIdType& endOut, mcIdType& stepOut, DataArrayIdType *&di) const;
    DataArrayIdType *computeTupleIdsToSelectFromCellIds(const MEDCouplingMesh *mesh, const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    void renumberValuesOnNodes(double epsOnVals, const mcIdType *old2New, mcIdType newNbOfNodes, DataArrayDouble *arr) const;
    void renumberValuesOnCells(double epsOnVals, const MEDCouplingMesh *mesh, const mcIdType *old2New, mcIdType newSz, DataArrayDouble *arr) const;
    void renumberValuesOnCellsR(const MEDCouplingMesh *mesh, const mcIdType *new2old, mcIdType newSz, DataArrayDouble *arr) const;
  public:
    void getValueOnPos(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, mcIdType i, mcIdType j, mcIdType k, double *res) const;
  };

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationP1 : public MEDCouplingFieldDiscretizationOnNodes
  {
  public:
    TypeOfField getEnum() const;
    std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationP1"); }
    MEDCouplingFieldDiscretization *clone() const override;
    std::string getStringRepr() const;
    const char *getRepr() const;
    void checkCompatibilityWithNature(NatureOfField nat) const override;
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
    void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
    DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    void reprQuickOverview(std::ostream& stream) const;
    MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
  public:
    static const char REPR[];
    static constexpr TypeOfField TYPE = ON_NODES;
  protected:
    void getValueInCell(const MEDCouplingMesh *mesh, mcIdType cellId, const DataArrayDouble *arr, const double *loc, double *res) const;
  };

  /*!
   * This class abstracts MEDCouplingFieldDiscretization that needs an information on each cell to perform their job.
   * All classes that inherits from this are more linked to mesh.
   */
  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationPerCell : public MEDCouplingFieldDiscretization
  {
  public:
    const DataArrayIdType *getArrayOfDiscIds() const;
    void setArrayOfDiscIds(const DataArrayIdType *adids);
    void checkNoOrphanCells() const;
    std::vector<DataArrayIdType *> splitIntoSingleGaussDicrPerCellType(std::vector< mcIdType >& locIds) const;
  protected:
    MEDCouplingFieldDiscretizationPerCell();
    MEDCouplingFieldDiscretizationPerCell(const MEDCouplingFieldDiscretizationPerCell& other, const mcIdType *startCellIds, const mcIdType *endCellIds);
    MEDCouplingFieldDiscretizationPerCell(const MEDCouplingFieldDiscretizationPerCell& other, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds);
    MEDCouplingFieldDiscretizationPerCell(DataArrayIdType *dpc);
    ~MEDCouplingFieldDiscretizationPerCell();
    void updateTime() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const;
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    bool isEqualWithoutConsideringStr(const MEDCouplingFieldDiscretization *other, double eps) const;
    void renumberCells(const mcIdType *old2NewBg, bool check);
  protected:
    void buildDiscrPerCellIfNecessary(const MEDCouplingMesh *mesh);
  protected:
    DataArrayIdType *_discr_per_cell;
    static const mcIdType DFT_INVALID_LOCID_VALUE;
  };

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationGauss : public MEDCouplingFieldDiscretizationPerCell
  {
  public:
    MEDCouplingFieldDiscretizationGauss();
    TypeOfField getEnum() const;
    std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationGauss"); }
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    bool isEqualWithoutConsideringStr(const MEDCouplingFieldDiscretization *other, double eps) const;
    MEDCouplingFieldDiscretization *clone() const override;
    MEDCouplingFieldDiscretization *clonePart(const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    MEDCouplingFieldDiscretization *clonePartRange(mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds) const;
    std::string getStringRepr() const;
    const char *getRepr() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    mcIdType getNumberOfTuplesExpectedRegardingCode(const std::vector<mcIdType>& code, const std::vector<const DataArrayIdType *>& idsPerType) const;
    mcIdType getNumberOfTuples(const MEDCouplingMesh *mesh) const;
    mcIdType getNumberOfMeshPlaces(const MEDCouplingMesh *mesh) const;
    DataArrayIdType *getOffsetArr(const MEDCouplingMesh *mesh) const;
    void renumberArraysForCell(const MEDCouplingMesh *mesh, const std::vector<DataArray *>& arrays,
                                                  const mcIdType *old2NewBg, bool check);
    DataArrayDouble *getLocalizationOfDiscValues(const MEDCouplingMesh *mesh) const;
    void computeMeshRestrictionFromTupleIds(const MEDCouplingMesh *mesh, const mcIdType *tupleIdsBg, const mcIdType *tupleIdsEnd,
                                                               DataArrayIdType *&cellRestriction, DataArrayIdType *&trueTupleRestriction) const;
    void checkCompatibilityWithNature(NatureOfField nat) const override;
    void getTinySerializationIntInformation(std::vector<mcIdType>& tinyInfo) const;
    void getTinySerializationDbleInformation(std::vector<double>& tinyInfo) const;
    void finishUnserialization(const std::vector<double>& tinyInfo);
    void getSerializationIntArray(DataArrayIdType *& arr) const;
    void resizeForUnserialization(const std::vector<mcIdType>& tinyInfo, DataArrayIdType *& arr);
    void checkForUnserialization(const std::vector<mcIdType>& tinyInfo, const DataArrayIdType *arr);
    double getIJK(const MEDCouplingMesh *mesh, const DataArrayDouble *da, mcIdType cellId, mcIdType nodeIdInCell, int compoId) const;
    void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const;
    MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
    void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
    void getValueOnPos(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, mcIdType i, mcIdType j, mcIdType k, double *res) const;
    DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    MEDCouplingMesh *buildSubMeshData(const MEDCouplingMesh *mesh, const mcIdType *start, const mcIdType *end, DataArrayIdType *&di) const;
    MEDCouplingMesh *buildSubMeshDataRange(const MEDCouplingMesh *mesh, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds, mcIdType& beginOut, mcIdType& endOut, mcIdType& stepOut, DataArrayIdType *&di) const;
    DataArrayIdType *computeTupleIdsToSelectFromCellIds(const MEDCouplingMesh *mesh, const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    void renumberValuesOnNodes(double epsOnVals, const mcIdType *old2New, mcIdType newNbOfNodes, DataArrayDouble *arr) const;
    void renumberValuesOnCells(double epsOnVals, const MEDCouplingMesh *mesh, const mcIdType *old2New, mcIdType newSz, DataArrayDouble *arr) const;
    void renumberValuesOnCellsR(const MEDCouplingMesh *mesh, const mcIdType *new2old, mcIdType newSz, DataArrayDouble *arr) const;
    MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
    void setGaussLocalizationOnType(const MEDCouplingMesh *mesh, INTERP_KERNEL::NormalizedCellType type, const std::vector<double>& refCoo,
                                                       const std::vector<double>& gsCoo, const std::vector<double>& wg);
    void setGaussLocalizationOnCells(const MEDCouplingMesh *mesh, const mcIdType *begin, const mcIdType *end, const std::vector<double>& refCoo,
                                                        const std::vector<double>& gsCoo, const std::vector<double>& wg);
    void clearGaussLocalizations();
    void setGaussLocalization(mcIdType locId, const MEDCouplingGaussLocalization& loc);
    void resizeLocalizationVector(mcIdType newSz);
    MEDCouplingGaussLocalization& getGaussLocalization(mcIdType locId);
    mcIdType getNbOfGaussLocalization() const;
    mcIdType getGaussLocalizationIdOfOneCell(mcIdType cellId) const;
    mcIdType getGaussLocalizationIdOfOneType(INTERP_KERNEL::NormalizedCellType type) const;
    std::set<mcIdType> getGaussLocalizationIdsOfOneType(INTERP_KERNEL::NormalizedCellType type) const;
    void getCellIdsHavingGaussLocalization(mcIdType locId, std::vector<mcIdType>& cellIds) const;
    const MEDCouplingGaussLocalization& getGaussLocalization(mcIdType locId) const;
    DataArrayIdType *buildNbOfGaussPointPerCellField() const;
    void reprQuickOverview(std::ostream& stream) const;
  protected:
    MEDCouplingFieldDiscretizationGauss(const MEDCouplingFieldDiscretizationGauss& other, const mcIdType *startCellIds=0, const mcIdType *endCellIds=0);
    MEDCouplingFieldDiscretizationGauss(const MEDCouplingFieldDiscretizationGauss& other, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds);
    MEDCouplingFieldDiscretizationGauss(DataArrayIdType *dpc, const std::vector<MEDCouplingGaussLocalization>& loc):MEDCouplingFieldDiscretizationPerCell(dpc),_loc(loc) { }
    void zipGaussLocalizations();
    mcIdType getOffsetOfCell(mcIdType cellId) const;
    void checkLocalizationId(mcIdType locId) const;
    void commonUnserialization(const std::vector<mcIdType>& tinyInfo);
  public:
    static const char REPR[];
    static constexpr TypeOfField TYPE = ON_GAUSS_PT;
  private:
    std::vector<MEDCouplingGaussLocalization> _loc;
  };

  /*!
   * Gauss with points of values located on nodes of element. This is a specialization of MEDCouplingFieldDiscretizationGauss.
   */
  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationGaussNE : public MEDCouplingFieldDiscretization
  {
  public:
    MEDCouplingFieldDiscretizationGaussNE();
    TypeOfField getEnum() const;
    std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationGaussNE"); }
    MEDCouplingFieldDiscretization *clone() const override;
    std::string getStringRepr() const;
    const char *getRepr() const;
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    mcIdType getNumberOfTuplesExpectedRegardingCode(const std::vector<mcIdType>& code, const std::vector<const DataArrayIdType *>& idsPerType) const;
    mcIdType getNumberOfTuples(const MEDCouplingMesh *mesh) const;
    mcIdType getNumberOfMeshPlaces(const MEDCouplingMesh *mesh) const;
    DataArrayIdType *getOffsetArr(const MEDCouplingMesh *mesh) const;
    void renumberArraysForCell(const MEDCouplingMesh *mesh, const std::vector<DataArray *>& arrays,
                                                  const mcIdType *old2NewBg, bool check);
    DataArrayDouble *getLocalizationOfDiscValues(const MEDCouplingMesh *mesh) const;
    void integral(const MEDCouplingMesh *mesh, const DataArrayDouble *arr, bool isWAbs, double *res) const;
    void computeMeshRestrictionFromTupleIds(const MEDCouplingMesh *mesh, const mcIdType *tupleIdsBg, const mcIdType *tupleIdsEnd,
                                                               DataArrayIdType *&cellRestriction, DataArrayIdType *&trueTupleRestriction) const;
    void checkCompatibilityWithNature(NatureOfField nat) const override;
    double getIJK(const MEDCouplingMesh *mesh, const DataArrayDouble *da, mcIdType cellId, mcIdType nodeIdInCell, int compoId) const;
    void checkCoherencyBetween(const MEDCouplingMesh *mesh, const DataArray *da) const;
    MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
    void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
    void getValueOnPos(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, mcIdType i, mcIdType j, mcIdType k, double *res) const;
    DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    MEDCouplingMesh *buildSubMeshData(const MEDCouplingMesh *mesh, const mcIdType *start, const mcIdType *end, DataArrayIdType *&di) const;
    MEDCouplingMesh *buildSubMeshDataRange(const MEDCouplingMesh *mesh, mcIdType beginCellIds, mcIdType endCellIds, mcIdType stepCellIds, mcIdType& beginOut, mcIdType& endOut, mcIdType& stepOut, DataArrayIdType *&di) const;
    DataArrayIdType *computeTupleIdsToSelectFromCellIds(const MEDCouplingMesh *mesh, const mcIdType *startCellIds, const mcIdType *endCellIds) const;
    void renumberValuesOnNodes(double epsOnVals, const mcIdType *old2New, mcIdType newNbOfNodes, DataArrayDouble *arr) const;
    void renumberValuesOnCells(double epsOnVals, const MEDCouplingMesh *mesh, const mcIdType *old2New, mcIdType newSz, DataArrayDouble *arr) const;
    void renumberValuesOnCellsR(const MEDCouplingMesh *mesh, const mcIdType *new2old, mcIdType newSz, DataArrayDouble *arr) const;
    MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
    void reprQuickOverview(std::ostream& stream) const;
    static const double *GetWeightArrayFromGeometricType(INTERP_KERNEL::NormalizedCellType geoType, std::size_t& lgth);
    static const double *GetRefCoordsFromGeometricType(INTERP_KERNEL::NormalizedCellType geoType, std::size_t& lgth);
    static const double *GetLocsFromGeometricType(INTERP_KERNEL::NormalizedCellType geoType, std::size_t& lgth);
  protected:
    MEDCouplingFieldDiscretizationGaussNE(const MEDCouplingFieldDiscretizationGaussNE& other);
  public:
    static const char REPR[];
    static constexpr TypeOfField TYPE = ON_GAUSS_NE;
    static const double FGP_POINT1[1];
    static const double FGP_SEG2[2];
    static const double FGP_SEG3[3];
    static const double FGP_SEG4[4];
    static const double FGP_TRI3[3];
    static const double FGP_TRI6[6];
    static const double FGP_TRI7[7];
    static const double FGP_QUAD4[4];
    static const double FGP_QUAD8[8];
    static const double FGP_QUAD9[9];
    static const double FGP_TETRA4[4];
    static const double FGP_TETRA10[10];//to check
    static const double FGP_PENTA6[6];
    static const double FGP_PENTA15[15];//to check
    static const double FGP_PENTA18[18];//to check
    static const double FGP_HEXA8[8];
    static const double FGP_HEXA20[20];//to check
    static const double FGP_HEXA27[27];
    static const double FGP_PYRA5[5];
    static const double FGP_PYRA13[13];//to check
    static const double REF_SEG2[2];
    static const double REF_SEG3[3];
    static const double REF_SEG4[4];
    static const double REF_TRI3[6];
    static const double REF_TRI6[12];
    static const double REF_TRI7[14];
    static const double REF_QUAD4[8];
    static const double REF_QUAD8[16];
    static const double REF_QUAD9[18];
    static const double REF_TETRA4[12];
    static const double REF_TETRA10[30];
    static const double REF_PENTA6[18];
    static const double REF_PENTA15[45];
    static const double REF_PENTA18[54];
    static const double REF_HEXA8[24];
    static const double REF_HEXA20[60];
    static const double REF_HEXA27[81];
    static const double REF_PYRA5[15];
    static const double REF_PYRA13[39];
    static const double LOC_SEG2[2];
    static const double LOC_SEG3[3];
    static const double LOC_SEG4[4];
    static const double LOC_TRI3[6];
    static const double LOC_TRI6[12];
    static const double LOC_TRI7[14];
    static const double LOC_QUAD4[8];
    static const double LOC_QUAD8[16];
    static const double LOC_QUAD9[18];
    static const double LOC_TETRA4[12];
    static const double LOC_TETRA10[30];//to check
    static const double LOC_PENTA6[18];
    static const double LOC_PENTA15[45];//to check
    static const double LOC_PENTA18[54];//to check
    static const double LOC_HEXA8[24];
    static const double LOC_HEXA20[60];//to check
    static const double LOC_HEXA27[81];
    static const double LOC_PYRA5[15];
    static const double LOC_PYRA13[39];//to check
  };

  class MEDCOUPLING_EXPORT MEDCouplingFieldDiscretizationKriging : public MEDCouplingFieldDiscretizationOnNodes
  {
  public:
    TypeOfField getEnum() const;
    std::string getClassName() const override { return std::string("MEDCouplingFieldDiscretizationKriging"); }
    const char *getRepr() const;
    MEDCouplingFieldDiscretization *clone() const override;
    std::string getStringRepr() const;
    void checkCompatibilityWithNature(NatureOfField nat) const override;
    bool isEqualIfNotWhy(const MEDCouplingFieldDiscretization *other, double eps, std::string& reason) const override;
    MEDCouplingFieldDouble *getMeasureField(const MEDCouplingMesh *mesh, bool isAbs) const override;
    void getValueOn(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, double *res) const override;
    DataArrayDouble *getValueOnMulti(const DataArrayDouble *arr, const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfPoints) const override;
    void reprQuickOverview(std::ostream& stream) const;
    MCAuto<MEDCouplingFieldDiscretization> aggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds) const override;
  public://specific part
    DataArrayDouble *computeEvaluationMatrixOnGivenPts(const MEDCouplingMesh *mesh, const double *loc, mcIdType nbOfTargetPoints, mcIdType& nbCols) const;
    DataArrayDouble *computeInverseMatrix(const MEDCouplingMesh *mesh, mcIdType& isDrift, mcIdType& matSz) const;
    DataArrayDouble *computeMatrix(const MEDCouplingMesh *mesh, mcIdType& isDrift, mcIdType& matSz) const;
    DataArrayDouble *computeVectorOfCoefficients(const MEDCouplingMesh *mesh, const DataArrayDouble *arr, mcIdType& isDrift) const;
    void operateOnDenseMatrix(int spaceDimension, mcIdType nbOfElems, double *matrixPtr) const;
    DataArrayDouble *performDrift(const DataArrayDouble *matr, const DataArrayDouble *arr, mcIdType& delta) const;
    static void OperateOnDenseMatrixH3(mcIdType nbOfElems, double *matrixPtr);
    static void OperateOnDenseMatrixH2Ln(mcIdType nbOfElems, double *matrixPtr);
    static DataArrayDouble *PerformDriftRect(const DataArrayDouble *matr, const DataArrayDouble *arr, mcIdType& delta);
    static DataArrayDouble *PerformDriftOfVec(const DataArrayDouble *arr, mcIdType isDrift);
  public:
    static const char REPR[];
    static constexpr TypeOfField TYPE = ON_NODES_KR;
  };
  
  template<class FIELD_DISC>
  MCAuto<MEDCouplingFieldDiscretization> MEDCouplingFieldDiscretization::EasyAggregate(std::vector<const MEDCouplingFieldDiscretization *>& fds)
  {
    if(fds.empty())
      throw INTERP_KERNEL::Exception("MEDCouplingFieldDiscretization::aggregate : input array is empty");
    for(const MEDCouplingFieldDiscretization * it : fds)
      {
        const FIELD_DISC *itc(dynamic_cast<const FIELD_DISC *>(it));
        if(!itc)
          throw INTERP_KERNEL::Exception("MEDCouplingFieldDiscretization::aggregate : same field discretization expected for all input discretizations !");
      }
    return fds[0]->clone();
  }
}

#endif
