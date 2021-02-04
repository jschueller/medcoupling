// Copyright (C) 2007-2020  CEA/DEN, EDF R&D
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

#ifndef __MEDFILEMESH_HXX__
#define __MEDFILEMESH_HXX__

#include "MEDLoaderDefines.hxx"
#include "MEDFileMeshLL.hxx"
#include "MEDFileUtilities.txx"
#include "MEDCouplingPartDefinition.hxx"
#include "MEDFileMeshReadSelector.hxx"
#include "MEDFileJoint.hxx"
#include "MEDFileEquivalence.hxx"

#include <map>
#include <list>

namespace MEDCoupling
{
  class MEDFileFieldGlobsReal;
  class MEDFileField1TSStructItem;

  class MEDLOADER_EXPORT MEDFileMesh : public RefCountObject, public MEDFileWritableStandAlone
  {
  public:
    static MEDFileMesh *New(const std::string& fileName, MEDFileMeshReadSelector *mrs=0);
    static MEDFileMesh *New(med_idt fid, MEDFileMeshReadSelector *mrs=0);
    static MEDFileMesh *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileMesh>(db); }
    static MEDFileMesh *New(const std::string& fileName, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0, MEDFileJoints* joints=0);
    static MEDFileMesh *New(med_idt fid, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0, MEDFileJoints* joints=0);
    void writeLL(med_idt fid) const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    virtual MEDFileMesh *createNewEmpty() const = 0;
    virtual MEDFileMesh *deepCopy() const = 0;
    virtual MEDFileMesh *shallowCpy() const = 0;
    virtual bool isEqual(const MEDFileMesh *other, double eps, std::string& what) const;
    virtual void clearNonDiscrAttributes() const;
    virtual void setName(const std::string& name);
    bool changeNames(const std::vector< std::pair<std::string,std::string> >& modifTab);
    std::string getName() const { return _name; }
    std::string getUnivName() const { return _univ_name; }
    bool getUnivNameWrStatus() const { return _univ_wr_status; }
    void setUnivNameWrStatus(bool newStatus) { _univ_wr_status=newStatus; }
    void setDescription(const std::string& name) { _desc_name=name; }
    std::string getDescription() const { return _desc_name; }
    void setOrder(int order) { _order=order; }
    int getOrder() const { return _order; }
    void setIteration(int it) { _iteration=it; }
    int getIteration() const { return _iteration; }
    void setTimeValue(double time) { _time=time; }
    void setTime(int dt, int it, double time) { _time=time; _iteration=dt; _order=it; }
    double getTime(int& dt, int& it) const { dt=_iteration; it=_order; return _time; }
    double getTimeValue() const { return _time; }
    void setTimeUnit(const std::string& unit) { _dt_unit=unit; }
    std::string getTimeUnit() const { return _dt_unit; }
    void setAxisType(MEDCouplingAxisType at) { _axis_type=at; }
    MEDCouplingAxisType getAxisType() const { return _axis_type; }
    std::vector<INTERP_KERNEL::NormalizedCellType> getAllGeoTypes() const;
    virtual mcIdType getNumberOfNodes() const = 0;
    virtual mcIdType getNumberOfCellsAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual bool hasImplicitPart() const = 0;
    virtual mcIdType buildImplicitPartIfAny(INTERP_KERNEL::NormalizedCellType gt) const = 0;
    virtual void releaseImplicitPartIfAny() const = 0;
    virtual std::vector<INTERP_KERNEL::NormalizedCellType> getGeoTypesAtLevel(int meshDimRelToMax) const = 0;
    virtual mcIdType getNumberOfCellsWithType(INTERP_KERNEL::NormalizedCellType ct) const = 0;
    virtual std::vector<int> getNonEmptyLevels() const = 0;
    virtual std::vector<int> getNonEmptyLevelsExt() const = 0;
    virtual std::vector<int> getFamArrNonEmptyLevelsExt() const = 0;
    virtual std::vector<int> getNumArrNonEmptyLevelsExt() const = 0;
    virtual std::vector<int> getNameArrNonEmptyLevelsExt() const = 0;
    virtual mcIdType getSizeAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual MEDCouplingMesh *getMeshAtLevel(int meshDimRelToMax, bool renum=false) const = 0;
    virtual std::vector<mcIdType> getDistributionOfTypes(int meshDimRelToMax) const;
    virtual void whichAreNodesFetched(const MEDFileField1TSStructItem& st, const MEDFileFieldGlobsReal *globs, std::vector<bool>& nodesFetched) const = 0;
    virtual MEDFileMesh *cartesianize() const = 0;
    virtual bool presenceOfStructureElements() const = 0;
    virtual void killStructureElements() { }
    //
    bool areFamsEqual(const MEDFileMesh *other, std::string& what) const;
    bool areGrpsEqual(const MEDFileMesh *other, std::string& what) const;
    bool existsGroup(const std::string& groupName) const;
    bool existsFamily(mcIdType famId) const;
    bool existsFamily(const std::string& familyName) const;
    void setFamilyId(const std::string& familyName, mcIdType id);
    void setFamilyIdUnique(const std::string& familyName, mcIdType id);
    virtual void addFamily(const std::string& familyName, mcIdType id);
    virtual void createGroupOnAll(int meshDimRelToMaxExt, const std::string& groupName);
    virtual bool keepFamIdsOnlyOnLevs(const std::vector<mcIdType>& famIds, const std::vector<int>& levs);
    void addFamilyOnGrp(const std::string& grpName, const std::string& famName);
    std::string findOrCreateAndGiveFamilyWithId(mcIdType id, bool& created);
    void setFamilyInfo(const std::map<std::string,mcIdType>& info);
    void setGroupInfo(const std::map<std::string, std::vector<std::string> >&info);
    void copyFamGrpMapsFrom(const MEDFileMesh& other);
    void clearGrpMap();
    void clearFamMap();
    void clearFamGrpMaps();
    const std::map<std::string,mcIdType>& getFamilyInfo() const { return _families; }
    const std::map<std::string, std::vector<std::string> >& getGroupInfo() const { return _groups; }
    std::vector<std::string> getFamiliesOnGroup(const std::string& name) const;
    std::vector<std::string> getFamiliesOnGroups(const std::vector<std::string>& grps) const;
    std::vector<mcIdType> getFamiliesIdsOnGroup(const std::string& name) const;
    void setFamiliesOnGroup(const std::string& name, const std::vector<std::string>& fams);
    void setFamiliesIdsOnGroup(const std::string& name, const std::vector<mcIdType>& famIds);
    std::vector<std::string> getGroupsOnFamily(const std::string& name) const;
    void setGroupsOnFamily(const std::string& famName, const std::vector<std::string>& grps);
    std::vector<std::string> getGroupsNames() const;
    std::vector<std::string> getFamiliesNames() const;
    std::vector<std::string> getGroupsOnSpecifiedLev(int meshDimRelToMaxExt) const;
    std::vector<mcIdType> getGrpNonEmptyLevelsExt(const std::string& grp) const;
    std::vector<mcIdType> getGrpNonEmptyLevels(const std::string& grp) const;
    std::vector<mcIdType> getGrpsNonEmptyLevels(const std::vector<std::string>& grps) const;
    std::vector<mcIdType> getGrpsNonEmptyLevelsExt(const std::vector<std::string>& grps) const;
    virtual std::vector<mcIdType> getFamsNonEmptyLevels(const std::vector<std::string>& fams) const = 0;
    virtual std::vector<mcIdType> getFamsNonEmptyLevelsExt(const std::vector<std::string>& fams) const = 0;
    std::vector<mcIdType> getFamNonEmptyLevels(const std::string& fam) const;
    std::vector<mcIdType> getFamNonEmptyLevelsExt(const std::string& fam) const;
    std::vector<std::string> getFamiliesNamesWithFilePointOfView() const;
    static std::string GetMagicFamilyStr();
    void assignFamilyNameWithGroupName();
    std::vector<std::string> removeEmptyGroups();
    void removeGroupAtLevel(int meshDimRelToMaxExt, const std::string& name);
    void removeGroup(const std::string& name);
    void removeFamily(const std::string& name);
    std::vector<std::string> removeOrphanGroups();
    std::vector<std::string> removeOrphanFamilies();
    void removeFamiliesReferedByNoGroups();
    void rearrangeFamilies();
    void zipFamilies();
    void checkOrphanFamilyZero() const;
    void changeGroupName(const std::string& oldName, const std::string& newName);
    void changeFamilyName(const std::string& oldName, const std::string& newName);
    void changeFamilyId(mcIdType oldId, mcIdType newId);
    void changeAllGroupsContainingFamily(const std::string& familyNameToChange, const std::vector<std::string>& newFamiliesNames);
    mcIdType getFamilyId(const std::string& name) const;
    mcIdType getMaxAbsFamilyId() const;
    mcIdType getMaxFamilyId() const;
    mcIdType getMinFamilyId() const;
    mcIdType getTheMaxAbsFamilyId() const;
    mcIdType getTheMaxFamilyId() const;
    mcIdType getTheMinFamilyId() const;
    virtual mcIdType getMaxAbsFamilyIdInArrays() const = 0;
    virtual mcIdType getMaxFamilyIdInArrays() const = 0;
    virtual mcIdType getMinFamilyIdInArrays() const = 0;
    DataArrayIdType *getAllFamiliesIdsReferenced() const;
    DataArrayIdType *computeAllFamilyIdsInUse() const;
    std::vector<mcIdType> getFamiliesIds(const std::vector<std::string>& famNames) const;
    std::string getFamilyNameGivenId(mcIdType id) const;
    bool ensureDifferentFamIdsPerLevel();
    void normalizeFamIdsTrio();
    void normalizeFamIdsMEDFile();
    virtual int getMeshDimension() const = 0;
    virtual int getSpaceDimension() const = 0;
    virtual std::string simpleRepr() const;
    virtual std::string advancedRepr() const = 0;
    //
    virtual void setGroupsAtLevel(int meshDimRelToMaxExt, const std::vector<const DataArrayIdType *>& grps, bool renum=false);
    virtual void setFamilyFieldArr(int meshDimRelToMaxExt, DataArrayIdType *famArr) = 0;
    virtual void setRenumFieldArr(int meshDimRelToMaxExt, DataArrayIdType *renumArr) = 0;
    virtual void setNameFieldAtLevel(int meshDimRelToMaxExt, DataArrayAsciiChar *nameArr) = 0;
    virtual void setGlobalNumFieldAtLevel(int meshDimRelToMaxExt, DataArrayIdType *globalNumArr) = 0;
    virtual void addNodeGroup(const DataArrayIdType *ids) = 0;
    virtual void addGroup(int meshDimRelToMaxExt, const DataArrayIdType *ids) = 0;
    virtual const DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt) = 0;
    DataArrayIdType *getOrCreateAndGetFamilyFieldAtLevel(int meshDimRelToMaxExt);
    virtual const DataArrayIdType *getNumberFieldAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual const DataArrayIdType *getRevNumberFieldAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual const DataArrayAsciiChar *getNameFieldAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual MCAuto<DataArrayIdType> getGlobalNumFieldAtLevel(int meshDimRelToMaxExt) const = 0;
    virtual DataArrayIdType *getFamiliesArr(int meshDimRelToMaxExt, const std::vector<std::string>& fams, bool renum=false) const = 0;
    virtual DataArrayIdType *getGroupsArr(int meshDimRelToMaxExt, const std::vector<std::string>& grps, bool renum=false) const;
    virtual DataArrayIdType *getGroupArr(int meshDimRelToMaxExt, const std::string& grp, bool renum=false) const;
    virtual DataArrayIdType *getFamilyArr(int meshDimRelToMaxExt, const std::string& fam, bool renum=false) const;
    virtual DataArrayIdType *getNodeGroupArr(const std::string& grp, bool renum=false) const;
    virtual DataArrayIdType *getNodeGroupsArr(const std::vector<std::string>& grps, bool renum=false) const;
    virtual DataArrayIdType *getNodeFamilyArr(const std::string& fam, bool renum=false) const;
    virtual DataArrayIdType *getNodeFamiliesArr(const std::vector<std::string>& fams, bool renum=false) const;
    // tools
    virtual bool unPolyze(std::vector<mcIdType>& oldCode, std::vector<mcIdType>& newCode, DataArrayIdType *& o2nRenumCell) = 0;
    int getNumberOfJoints() const;
    MEDFileJoints *getJoints() const;
    void setJoints( MEDFileJoints* joints );
    MEDFileEquivalences *getEquivalences() { return _equiv; }
    const MEDFileEquivalences *getEquivalences() const { return _equiv; }
    void killEquivalences() { _equiv=(MEDFileEquivalences *)0; }
    void initializeEquivalences() { _equiv=MEDFileEquivalences::New(this); }
    static INTERP_KERNEL::NormalizedCellType ConvertFromMEDFileGeoType(med_geometry_type geoType);
    static TypeOfField ConvertFromMEDFileEntity(med_entity_type etype);
  protected:
    MEDFileMesh();
    //! protected because no way in MED file API to specify this name
    void setUnivName(const std::string& name) { _univ_name=name; }
    void addFamilyOnAllGroupsHaving(const std::string& famName, const std::string& otherFamName);
    void dealWithTinyInfo(const MEDCouplingMesh *m);
    virtual void synchronizeTinyInfoOnLeaves() const = 0;
    void getFamilyRepr(std::ostream& oss) const;
    virtual void appendFamilyEntries(const DataArrayIdType *famIds, const std::vector< std::vector<mcIdType> >& fidsOfGrps, const std::vector<std::string>& grpNames);
    virtual void changeFamilyIdArr(mcIdType oldId, mcIdType newId) = 0;
    virtual std::list< MCAuto<DataArrayIdType> > getAllNonNullFamilyIds() const = 0;
    virtual void loadLL(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs) = 0;
    void loadLLWithAdditionalItems(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    void addGroupUnderground(bool isNodeGroup, const DataArrayIdType *ids, DataArrayIdType *famArr);
    static void TranslateFamilyIds(mcIdType offset, DataArrayIdType *famArr, std::vector< std::vector<mcIdType> >& famIdsPerGrp);
    static void ChangeAllGroupsContainingFamily(std::map<std::string, std::vector<std::string> >& groups, const std::string& familyNameToChange, const std::vector<std::string>& newFamiliesNames);
    static std::string FindOrCreateAndGiveFamilyWithId(std::map<std::string,mcIdType>& families, mcIdType id, bool& created);
    static std::string CreateNameNotIn(const std::string& nameTry, const std::vector<std::string>& namesToAvoid);
    static mcIdType PutInThirdComponentOfCodeOffset(std::vector<mcIdType>& code, mcIdType strt);
    void writeJoints(med_idt fid) const;
    void loadJointsFromFile(med_idt fid, MEDFileJoints *toUseInstedOfReading=0);
    void loadEquivalences(med_idt fid);
    void deepCpyEquivalences(const MEDFileMesh& other);
    bool areEquivalencesEqual(const MEDFileMesh *other, std::string& what) const;
    void getEquivalencesRepr(std::ostream& oss) const;
    void checkCartesian() const;
    void checkNoGroupClash(const DataArrayIdType *famArr, const std::string& grpName) const;
  private:
    virtual void writeMeshLL(med_idt fid) const = 0;
  protected:
    int _order;
    int _iteration;
    double _time;
    std::string _dt_unit;
    std::string _name;
    //! this attribute do not impact the state of instance -> mutable
    mutable std::string _univ_name;
    bool _univ_wr_status;
    std::string _desc_name;
    MEDCouplingAxisType _axis_type;
    MCAuto<MEDFileJoints> _joints;
    MCAuto<MEDFileEquivalences> _equiv;
  protected:
    std::map<std::string, std::vector<std::string> > _groups;
    std::map<std::string,mcIdType> _families;
  public:
    static const char DFT_FAM_NAME[];
  };

  class MEDCouplingMappedExtrudedMesh;
  
  class MEDLOADER_EXPORT MEDFileUMesh : public MEDFileMesh
  {
    friend class MEDFileMesh;
  public:
    static MEDFileUMesh *New(const std::string& fileName, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static MEDFileUMesh *New(med_idt fid, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static MEDFileUMesh *New(const std::string& fileName, MEDFileMeshReadSelector *mrs=0);
    static MEDFileUMesh *New(med_idt fid, MEDFileMeshReadSelector *mrs=0);
    static MEDFileUMesh *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileUMesh>(db); }
    static MEDFileUMesh *New(const MEDCouplingMappedExtrudedMesh *mem);
    static MEDFileUMesh *New();
    std::string getClassName() const override { return std::string("MEDFileUMesh"); }
    static MEDFileUMesh *LoadPartOf(const std::string& fileName, const std::string& mName, const std::vector<INTERP_KERNEL::NormalizedCellType>& types, const std::vector<mcIdType>& slicPerTyp, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static MEDFileUMesh *LoadPartOf(med_idt fid, const std::string& mName, const std::vector<INTERP_KERNEL::NormalizedCellType>& types, const std::vector<mcIdType>& slicPerTyp, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static void LoadPartCoords(const std::string& fileName, const std::string& mName, int dt, int it, const std::vector<std::string>& infosOnComp, mcIdType startNodeId, mcIdType stopNodeId,
MCAuto<DataArrayDouble>& coords, MCAuto<PartDefinition>& partCoords, MCAuto<DataArrayIdType>& famCoords, MCAuto<DataArrayIdType>& numCoords, MCAuto<DataArrayAsciiChar>& nameCoords);
    static const char *GetSpeStr4ExtMesh() { return SPE_FAM_STR_EXTRUDED_MESH; }
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    MEDFileMesh *createNewEmpty() const;
    MEDFileUMesh *deepCopy() const;
    MEDFileUMesh *shallowCpy() const;
    bool isEqual(const MEDFileMesh *other, double eps, std::string& what) const;
    void checkConsistency() const;
    void checkSMESHConsistency() const;
    void clearNodeAndCellNumbers();
    void clearNonDiscrAttributes() const;
    void setName(const std::string& name);
    const std::vector< MCAuto<MEDFileEltStruct4Mesh> >& getAccessOfUndergroundEltStrs() const { return _elt_str; }
    //
    mcIdType getMaxAbsFamilyIdInArrays() const;
    mcIdType getMaxFamilyIdInArrays() const;
    mcIdType getMinFamilyIdInArrays() const;
    int getMeshDimension() const;
    int getSpaceDimension() const;
    std::string simpleRepr() const;
    std::string advancedRepr() const;
    mcIdType getSizeAtLevel(int meshDimRelToMaxExt) const;
    const DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt) const;
    DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt);
    const DataArrayIdType *getNumberFieldAtLevel(int meshDimRelToMaxExt) const;
    const DataArrayIdType *getRevNumberFieldAtLevel(int meshDimRelToMaxExt) const;
    const DataArrayAsciiChar *getNameFieldAtLevel(int meshDimRelToMaxExt) const;
    MCAuto<DataArrayIdType> getGlobalNumFieldAtLevel(int meshDimRelToMaxExt) const;
    const PartDefinition *getPartDefAtLevel(int meshDimRelToMaxExt, INTERP_KERNEL::NormalizedCellType gt=INTERP_KERNEL::NORM_ERROR) const;
    mcIdType getNumberOfNodes() const;
    mcIdType getNumberOfCellsAtLevel(int meshDimRelToMaxExt) const;
    bool hasImplicitPart() const;
    mcIdType buildImplicitPartIfAny(INTERP_KERNEL::NormalizedCellType gt) const;
    void releaseImplicitPartIfAny() const;
    std::vector<INTERP_KERNEL::NormalizedCellType> getGeoTypesAtLevel(int meshDimRelToMax) const;
    mcIdType getNumberOfCellsWithType(INTERP_KERNEL::NormalizedCellType ct) const;
    void whichAreNodesFetched(const MEDFileField1TSStructItem& st, const MEDFileFieldGlobsReal *globs, std::vector<bool>& nodesFetched) const;
    MEDFileMesh *cartesianize() const;
    bool presenceOfStructureElements() const;
    void killStructureElements();
    std::vector<int> getNonEmptyLevels() const;
    std::vector<int> getNonEmptyLevelsExt() const;
    std::vector<int> getFamArrNonEmptyLevelsExt() const;
    std::vector<int> getNumArrNonEmptyLevelsExt() const;
    std::vector<int> getNameArrNonEmptyLevelsExt() const;
    std::vector<mcIdType> getFamsNonEmptyLevels(const std::vector<std::string>& fams) const;
    std::vector<mcIdType> getFamsNonEmptyLevelsExt(const std::vector<std::string>& fams) const;
    DataArrayDouble *getCoords() const;
    MEDCouplingUMesh *getGroup(int meshDimRelToMaxExt, const std::string& grp, bool renum=false) const;
    MEDCouplingUMesh *getGroups(int meshDimRelToMaxExt, const std::vector<std::string>& grps, bool renum=false) const;
    MEDCouplingUMesh *getFamily(int meshDimRelToMaxExt, const std::string& fam, bool renum=false) const;
    MEDCouplingUMesh *getFamilies(int meshDimRelToMaxExt, const std::vector<std::string>& fams, bool renum=false) const;
    DataArrayIdType *getFamiliesArr(int meshDimRelToMaxExt, const std::vector<std::string>& fams, bool renum=false) const;
    MEDCouplingUMesh *getMeshAtLevel(int meshDimRelToMax, bool renum=false) const;
    std::vector<mcIdType> getDistributionOfTypes(int meshDimRelToMax) const;
    std::vector< std::pair<int,mcIdType> > getAllDistributionOfTypes() const;
    MEDCouplingUMesh *getLevel0Mesh(bool renum=false) const;
    MEDCouplingUMesh *getLevelM1Mesh(bool renum=false) const;
    MEDCouplingUMesh *getLevelM2Mesh(bool renum=false) const;
    MEDCouplingUMesh *getLevelM3Mesh(bool renum=false) const;
    void forceComputationOfParts() const;
    void computeRevNum() const;
    std::vector<MEDCoupling1GTUMesh *> getDirectUndergroundSingleGeoTypeMeshes(int meshDimRelToMax) const;
    MEDCoupling1GTUMesh *getDirectUndergroundSingleGeoTypeMesh(INTERP_KERNEL::NormalizedCellType gt) const;
    DataArrayIdType *extractFamilyFieldOnGeoType(INTERP_KERNEL::NormalizedCellType gt) const;
    DataArrayIdType *extractNumberFieldOnGeoType(INTERP_KERNEL::NormalizedCellType gt) const;
    int getRelativeLevOnGeoType(INTERP_KERNEL::NormalizedCellType gt) const;
    //
    void setFamilyNameAttachedOnId(mcIdType id, const std::string& newFamName);
    void setCoords(DataArrayDouble *coords);
    void setCoordsForced(DataArrayDouble *coords);
    void eraseGroupsAtLevel(int meshDimRelToMaxExt);
    void setFamilyFieldArr(int meshDimRelToMaxExt, DataArrayIdType *famArr);
    void setRenumFieldArr(int meshDimRelToMaxExt, DataArrayIdType *renumArr);
    void setNameFieldAtLevel(int meshDimRelToMaxExt, DataArrayAsciiChar *nameArr);
    void setGlobalNumFieldAtLevel(int meshDimRelToMaxExt, DataArrayIdType *globalNumArr);
    void addNodeGroup(const DataArrayIdType *ids);
    void addGroup(int meshDimRelToMaxExt, const DataArrayIdType *ids);
    void removeMeshAtLevel(int meshDimRelToMax);
    void setMeshAtLevel(int meshDimRelToMax, MEDCoupling1GTUMesh *m);
    void setMeshAtLevel(int meshDimRelToMax, MEDCouplingUMesh *m, bool newOrOld=false);
    void setMeshes(const std::vector<const MEDCouplingUMesh *>& ms, bool renum=false);
    void setGroupsFromScratch(int meshDimRelToMax, const std::vector<const MEDCouplingUMesh *>& ms, bool renum=false);
    void setGroupsOnSetMesh(int meshDimRelToMax, const std::vector<const MEDCouplingUMesh *>& ms, bool renum=false);
    void optimizeFamilies();
    // tools
    void buildInnerBoundaryAlongM1Group(const std::string& grpNameM1, DataArrayIdType *&nodesDuplicated, DataArrayIdType *&cellsModified, DataArrayIdType *&cellsNotModified);
    bool unPolyze(std::vector<mcIdType>& oldCode, std::vector<mcIdType>& newCode, DataArrayIdType *& o2nRenumCell);
    DataArrayIdType *zipCoords();
    DataArrayIdType *computeFetchedNodeIds() const;
    DataArrayIdType *deduceNodeSubPartFromCellSubPart(const std::map<int, MCAuto<DataArrayIdType> >& extractDef) const;
    MEDFileUMesh *extractPart(const std::map<int, MCAuto<DataArrayIdType> >& extractDef) const;
    MEDFileUMesh *buildExtrudedMesh(const MEDCouplingUMesh *m1D, int policy) const;
    MEDFileUMesh *linearToQuadratic(int conversionType=0, double eps=1e-12) const;
    MEDFileUMesh *quadraticToLinear(double eps=1e-12) const;
    MCAuto<MEDFileUMesh> symmetry3DPlane(const double point[3], const double normalVector[3]) const;
    static MCAuto<MEDFileUMesh> Aggregate(const std::vector<const MEDFileUMesh *>& meshes);
    MEDCouplingMappedExtrudedMesh *convertToExtrudedMesh() const;
    // serialization
    void serialize(std::vector<double>& tinyDouble, std::vector<mcIdType>& tinyInt, std::vector<std::string>& tinyStr,
                                    std::vector< MCAuto<DataArrayIdType> >& bigArraysI, MCAuto<DataArrayDouble>& bigArrayD);
    void unserialize(std::vector<double>& tinyDouble, std::vector<mcIdType>& tinyInt, std::vector<std::string>& tinyStr,
                                      std::vector< MCAuto<DataArrayIdType> >& bigArraysI, MCAuto<DataArrayDouble>& bigArrayD);
  private:
    ~MEDFileUMesh();
    void writeMeshLL(med_idt fid) const;
    MEDFileUMesh();
    MEDFileUMesh(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    void loadPartUMeshFromFile(med_idt fid, const std::string& mName, const std::vector<INTERP_KERNEL::NormalizedCellType>& types, const std::vector<mcIdType>& slicPerTyp, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    void loadLL(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    void dispatchLoadedPart(med_idt fid, const MEDFileUMeshL2& loaderl2, const std::string& mName, MEDFileMeshReadSelector *mrs);
    const MEDFileUMeshSplitL1 *getMeshAtLevSafe(int meshDimRelToMaxExt) const;
    MEDFileUMeshSplitL1 *getMeshAtLevSafe(int meshDimRelToMaxExt);
    void checkMeshDimCoherency(int meshDim, int meshDimRelToMax) const;
    DataArrayDouble *checkMultiMesh(const std::vector<const MEDCouplingUMesh *>& ms) const;
    void synchronizeTinyInfoOnLeaves() const;
    void changeFamilyIdArr(mcIdType oldId, mcIdType newId);
    std::list< MCAuto<DataArrayIdType> > getAllNonNullFamilyIds() const;
    MCAuto<MEDFileUMeshSplitL1>& checkAndGiveEntryInSplitL1(int meshDimRelToMax, MEDCouplingPointSet *m);
  private:
    static const char SPE_FAM_STR_EXTRUDED_MESH[];
  private:
    std::vector< MCAuto<MEDFileUMeshSplitL1> > _ms;   ///< The array of single-dimension constituting meshes, stored in decreasing order (dimRelativeToMax=0,-1,-2, ...)
    MCAuto<DataArrayDouble> _coords;
    MCAuto<DataArrayIdType> _fam_coords;              ///< Node family indices
    MCAuto<DataArrayIdType> _num_coords;
    MCAuto<DataArrayIdType> _global_num_coords;
    MCAuto<DataArrayAsciiChar> _name_coords;
    mutable MCAuto<DataArrayIdType> _rev_num_coords;
    MCAuto<PartDefinition> _part_coords;
    std::vector< MCAuto<MEDFileEltStruct4Mesh> > _elt_str;
  };

  class MEDLOADER_EXPORT MEDFileStructuredMesh : public MEDFileMesh
  {
    friend class MEDFileMesh;
  public:
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    mcIdType getMaxAbsFamilyIdInArrays() const;
    mcIdType getMaxFamilyIdInArrays() const;
    mcIdType getMinFamilyIdInArrays() const;
    bool isEqual(const MEDFileMesh *other, double eps, std::string& what) const;
    void clearNonDiscrAttributes() const;
    DataArrayIdType *getFamiliesArr(int meshDimRelToMaxExt, const std::vector<std::string>& fams, bool renum=false) const;
    const DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt) const;
    DataArrayIdType *getFamilyFieldAtLevel(int meshDimRelToMaxExt);
    void setFamilyFieldArr(int meshDimRelToMaxExt, DataArrayIdType *famArr);
    void setRenumFieldArr(int meshDimRelToMaxExt, DataArrayIdType *renumArr);
    void setNameFieldAtLevel(int meshDimRelToMaxExt, DataArrayAsciiChar *nameArr);
    void setGlobalNumFieldAtLevel(int meshDimRelToMaxExt, DataArrayIdType *globalNumArr);
    void addNodeGroup(const DataArrayIdType *ids);
    void addGroup(int meshDimRelToMaxExt, const DataArrayIdType *ids);
    const DataArrayIdType *getNumberFieldAtLevel(int meshDimRelToMaxExt) const;
    const DataArrayIdType *getRevNumberFieldAtLevel(int meshDimRelToMaxExt) const;
    const DataArrayAsciiChar *getNameFieldAtLevel(int meshDimRelToMaxExt) const;
    MCAuto<DataArrayIdType> getGlobalNumFieldAtLevel(int meshDimRelToMaxExt) const;
    std::vector<int> getNonEmptyLevels() const;
    std::vector<int> getNonEmptyLevelsExt() const;
    std::vector<int> getFamArrNonEmptyLevelsExt() const;
    std::vector<int> getNumArrNonEmptyLevelsExt() const;
    std::vector<int> getNameArrNonEmptyLevelsExt() const;
    MEDCouplingMesh *getMeshAtLevel(int meshDimRelToMax, bool renum=false) const;
    std::vector<mcIdType> getFamsNonEmptyLevels(const std::vector<std::string>& fams) const;
    std::vector<mcIdType> getFamsNonEmptyLevelsExt(const std::vector<std::string>& fams) const;
    mcIdType getSizeAtLevel(int meshDimRelToMaxExt) const;
    mcIdType getNumberOfNodes() const;
    mcIdType getNumberOfCellsAtLevel(int meshDimRelToMaxExt) const;
    bool hasImplicitPart() const;
    mcIdType buildImplicitPartIfAny(INTERP_KERNEL::NormalizedCellType gt) const;
    void releaseImplicitPartIfAny() const;
    MEDCoupling1SGTUMesh *getImplicitFaceMesh() const;
    std::vector<INTERP_KERNEL::NormalizedCellType> getGeoTypesAtLevel(int meshDimRelToMax) const;
    mcIdType getNumberOfCellsWithType(INTERP_KERNEL::NormalizedCellType ct) const;
    void whichAreNodesFetched(const MEDFileField1TSStructItem& st, const MEDFileFieldGlobsReal *globs, std::vector<bool>& nodesFetched) const;
    bool presenceOfStructureElements() const { return false; }
    virtual const MEDCouplingStructuredMesh *getStructuredMesh() const = 0;
    // tools
    bool unPolyze(std::vector<mcIdType>& oldCode, std::vector<mcIdType>& newCode, DataArrayIdType *& o2nRenumCell);
  protected:
    ~MEDFileStructuredMesh() { }
    void changeFamilyIdArr(mcIdType oldId, mcIdType newId);
    std::list< MCAuto<DataArrayIdType> > getAllNonNullFamilyIds() const;
    void deepCpyAttributes();
    void loadStrMeshFromFile(MEDFileStrMeshL2 *strm, med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    void writeStructuredLL(med_idt fid, const std::string& maa) const;
    void buildImplicitPart() const;
    void buildMinusOneImplicitPartIfNeeded() const;
    static med_geometry_type GetGeoTypeFromMeshDim(int meshDim);
  private:
    static void LoadStrMeshDAFromFile(med_idt fid, int meshDim, int dt, int it, const std::string& mName, MEDFileMeshReadSelector *mrs,
                                      MCAuto<DataArrayIdType>& famCells, MCAuto<DataArrayIdType>& numCells, MCAuto<DataArrayAsciiChar>& namesCells);
  private:
    MCAuto<DataArrayIdType> _fam_nodes;
    MCAuto<DataArrayIdType> _num_nodes;
    MCAuto<DataArrayAsciiChar> _names_nodes;
    MCAuto<DataArrayIdType> _fam_cells;
    MCAuto<DataArrayIdType> _num_cells;
    MCAuto<DataArrayAsciiChar> _names_cells;
    MCAuto<DataArrayIdType> _fam_faces;
    MCAuto<DataArrayIdType> _num_faces;
    MCAuto<DataArrayAsciiChar> _names_faces;
    mutable MCAuto<DataArrayIdType> _rev_num_nodes;
    mutable MCAuto<DataArrayIdType> _rev_num_cells;
    mutable MCAuto<MEDCoupling1SGTUMesh> _faces_if_necessary;
  };

  class MEDLOADER_EXPORT MEDFileCMesh : public MEDFileStructuredMesh
  {
    friend class MEDFileMesh;
  public:
    static MEDFileCMesh *New();
    static MEDFileCMesh *New(const std::string& fileName, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCMesh *New(med_idt fid, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCMesh *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileCMesh>(db); }
    static MEDFileCMesh *New(const std::string& fileName, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCMesh *New(med_idt fid, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    std::string getClassName() const override { return std::string("MEDFileCMesh"); }
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    MEDFileMesh *createNewEmpty() const;
    MEDFileCMesh *deepCopy() const;
    MEDFileCMesh *shallowCpy() const;
    bool isEqual(const MEDFileMesh *other, double eps, std::string& what) const;
    int getMeshDimension() const;
    int getSpaceDimension() const;
    std::string simpleRepr() const;
    std::string advancedRepr() const;
    void clearNonDiscrAttributes() const;
    const MEDCouplingCMesh *getMesh() const;
    void setMesh(MEDCouplingCMesh *m);
    MEDFileMesh *cartesianize() const;
  private:
    ~MEDFileCMesh() { }
    const MEDCouplingStructuredMesh *getStructuredMesh() const;
    void writeMeshLL(med_idt fid) const;
    MEDFileCMesh();
    void synchronizeTinyInfoOnLeaves() const;
    MEDFileCMesh(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    void loadLL(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
  private:
    MCAuto<MEDCouplingCMesh> _cmesh;
  };

  class MEDLOADER_EXPORT MEDFileCurveLinearMesh : public MEDFileStructuredMesh
  {
    friend class MEDFileMesh;
  public:
    static MEDFileCurveLinearMesh *New();
    static MEDFileCurveLinearMesh *New(const std::string& fileName, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCurveLinearMesh *New(med_idt fid, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCurveLinearMesh *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileCurveLinearMesh>(db); }
    static MEDFileCurveLinearMesh *New(const std::string& fileName, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    static MEDFileCurveLinearMesh *New(med_idt fid, const std::string& mName, int dt=-1, int it=-1, MEDFileMeshReadSelector *mrs=0);
    std::string getClassName() const override { return std::string("MEDFileCurveLinearMesh"); }
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    MEDFileMesh *createNewEmpty() const;
    MEDFileCurveLinearMesh *deepCopy() const;
    MEDFileCurveLinearMesh *shallowCpy() const;
    bool isEqual(const MEDFileMesh *other, double eps, std::string& what) const;
    int getMeshDimension() const;
    int getSpaceDimension() const;
    std::string simpleRepr() const;
    std::string advancedRepr() const;
    void clearNonDiscrAttributes() const;
    const MEDCouplingCurveLinearMesh *getMesh() const;
    void setMesh(MEDCouplingCurveLinearMesh *m);
    MEDFileMesh *cartesianize() const;
  private:
    ~MEDFileCurveLinearMesh() { }
    MEDFileCurveLinearMesh();
    MEDFileCurveLinearMesh(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);
    const MEDCouplingStructuredMesh *getStructuredMesh() const;
    void synchronizeTinyInfoOnLeaves() const;
    void writeMeshLL(med_idt fid) const;
    void loadLL(med_idt fid, const std::string& mName, int dt, int it, MEDFileMeshReadSelector *mrs);//to imp
  private:
    MCAuto<MEDCouplingCurveLinearMesh> _clmesh;
  };

  class MEDLOADER_EXPORT MEDFileMeshMultiTS : public RefCountObject, public MEDFileWritableStandAlone
  {
  public:
    static MEDFileMeshMultiTS *New();
    static MEDFileMeshMultiTS *New(med_idt fid);
    static MEDFileMeshMultiTS *New(const std::string& fileName);
    static MEDFileMeshMultiTS *New(med_idt fid, const std::string& mName);
    static MEDFileMeshMultiTS *New(const std::string& fileName, const std::string& mName);
    std::string getClassName() const override { return std::string("MEDFileMeshMultiTS"); }
    MEDFileMeshMultiTS *deepCopy() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    std::string getName() const;
    void setName(const std::string& newMeshName);
    bool changeNames(const std::vector< std::pair<std::string,std::string> >& modifTab);
    void cartesianizeMe();
    MEDFileMesh *getOneTimeStep() const;
    void writeLL(med_idt fid) const;
    void setOneTimeStep(MEDFileMesh *mesh1TimeStep);
    MEDFileJoints *getJoints() const;
    void setJoints(MEDFileJoints* joints);
    bool presenceOfStructureElements() const;
    void killStructureElements();
  private:
    ~MEDFileMeshMultiTS() { }
    void loadFromFile(med_idt fid, const std::string& mName);
    MEDFileMeshMultiTS();
    MEDFileMeshMultiTS(med_idt fid);
    MEDFileMeshMultiTS(med_idt fid, const std::string& mName);
  private:
    std::vector< MCAuto<MEDFileMesh> > _mesh_one_ts;
  };

  class MEDFileMeshesIterator;

  class MEDLOADER_EXPORT MEDFileMeshes : public RefCountObject, public MEDFileWritableStandAlone
  {
  public:
    static MEDFileMeshes *New();
    static MEDFileMeshes *New(med_idt fid);
    static MEDFileMeshes *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileMeshes>(db); }
    static MEDFileMeshes *New(const std::string& fileName);
    std::string getClassName() const override { return std::string("MEDFileMeshes"); }
    MEDFileMeshes *deepCopy() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    std::string simpleRepr() const;
    void simpleReprWithoutHeader(std::ostream& oss) const;
    void writeLL(med_idt fid) const;
    int getNumberOfMeshes() const;
    MEDFileMeshesIterator *iterator();
    MEDFileMesh *getMeshAtPos(int i) const;
    MEDFileMesh *getMeshWithName(const std::string& mname) const;
    std::vector<std::string> getMeshesNames() const;
    bool changeNames(const std::vector< std::pair<std::string,std::string> >& modifTab);
    void cartesianizeMe();
    //
    void resize(int newSize);
    void pushMesh(MEDFileMesh *mesh);
    void setMeshAtPos(int i, MEDFileMesh *mesh);
    void destroyMeshAtPos(int i);
    bool presenceOfStructureElements() const;
    void killStructureElements();
  private:
    ~MEDFileMeshes() { }
    void checkConsistencyLight() const;
    void loadFromFile(med_idt fid);
    MEDFileMeshes();
    MEDFileMeshes(med_idt fid);
  private:
    std::vector< MCAuto<MEDFileMeshMultiTS> > _meshes;
  };

  class MEDFileMeshesIterator
  {
  public:
    MEDFileMeshesIterator(MEDFileMeshes *ms);
    ~MEDFileMeshesIterator();
    MEDFileMesh *nextt();
  private:
    MCAuto<MEDFileMeshes> _ms;
    int _iter_id;
    int _nb_iter;
  };
}

#endif
