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
// Author : Anthony Geay (EDF R&D)

#pragma once

#include "MEDLoaderDefines.hxx"

#include "MEDFileFieldInternal.hxx"
#include "MEDFileFieldGlobs.hxx"
#include "MEDFileField1TS.hxx"
#include "MEDFileFieldMultiTS.hxx"

#include "MEDFileFieldOverView.hxx"
#include "MEDFileUtilities.txx"
#include "MEDFileEntities.hxx"

#include "MCAuto.hxx"
#include "MEDLoaderTraits.hxx"
#include "MEDCouplingTraits.hxx"
#include "MEDCouplingRefCountObject.hxx"
#include "MEDCouplingMemArray.hxx"
#include "MEDCouplingPartDefinition.hxx"

#include "NormalizedUnstructuredMesh.hxx"
#include "InterpKernelException.hxx"

#include <vector>
#include <string>
#include <list>
#include <set>

#include "med.h"

namespace MEDCoupling
{
  class MEDFileFieldGlobs;
  class MEDCouplingMesh;
  class MEDCouplingFieldDouble;
  class MEDFileMesh;
  class MEDFileFieldVisitor;

  class MEDFileMeshes;

  class MEDFileFieldsIterator;
  class MEDFileStructureElements;
  
  /*!
   * Use class.
   */
  class MEDLOADER_EXPORT MEDFileFields : public RefCountObject, public MEDFileFieldGlobsReal, public MEDFileWritableStandAlone
  {
  public:
    static MEDFileFields *New();
    static MEDFileFields *New(const std::string& fileName, bool loadAll=true);
    static MEDFileFields *New(med_idt fid, bool loadAll=true);
    static MEDFileFields *NewAdv(const std::string& fileName, bool loadAll, const MEDFileEntities *entities);
    static MEDFileFields *NewAdv(med_idt fid, bool loadAll, const MEDFileEntities *entities);
    static MEDFileFields *NewWithDynGT(const std::string& fileName, const MEDFileStructureElements *se, bool loadAll=true);
    static MEDFileFields *NewWithDynGT(med_idt fid, const MEDFileStructureElements *se, bool loadAll=true);
    static MEDFileFields *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileFields>(db); }
    std::string getClassName() const override { return std::string("MEDFileFields"); }
    static MEDFileFields *LoadPartOf(const std::string& fileName, bool loadAll=true, const MEDFileMeshes *ms=0);
    static MEDFileFields *LoadSpecificEntities(const std::string& fileName, const std::vector< std::pair<TypeOfField,INTERP_KERNEL::NormalizedCellType> >& entities, bool loadAll=true);
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    MEDFileFields *deepCopy() const;
    MEDFileFields *shallowCpy() const;
    void writeLL(med_idt fid) const;
    void loadArrays();
    void loadArraysIfNecessary();
    void unloadArrays();
    void unloadArraysWithoutDataLoss();
    int getNumberOfFields() const;
    std::vector< std::pair<int,int> > getCommonIterations(bool& areThereSomeForgottenTS) const;
    std::vector<std::string> getFieldsNames() const;
    std::vector<std::string> getMeshesNames() const;
    std::string simpleRepr() const;
    void simpleRepr(int bkOffset, std::ostream& oss) const;
    //
    void resize(int newSize);
    void pushField(MEDFileAnyTypeFieldMultiTS *field);
    void pushFields(const std::vector<MEDFileAnyTypeFieldMultiTS *>& fields);
    void setFieldAtPos(int i, MEDFileAnyTypeFieldMultiTS *field);
    int getPosFromFieldName(const std::string& fieldName) const;
    MEDFileAnyTypeFieldMultiTS *getFieldAtPos(int i) const;
    MEDFileAnyTypeFieldMultiTS *getFieldWithName(const std::string& fieldName) const;
    MEDFileFields *buildSubPart(const int *startIds, const int *endIds) const;
    bool removeFieldsWithoutAnyTimeStep();
    MEDFileFields *partOfThisLyingOnSpecifiedMeshName(const std::string& meshName) const;
    MEDFileFields *partOfThisLyingOnSpecifiedTimeSteps(const std::vector< std::pair<int,int> >& timeSteps) const;
    MEDFileFields *partOfThisNotLyingOnSpecifiedTimeSteps(const std::vector< std::pair<int,int> >& timeSteps) const;
    bool presenceOfStructureElements() const;
    void killStructureElements();
    void keepOnlyStructureElements();
    void keepOnlyOnMeshSE(const std::string& meshName, const std::string& seName);
    void getMeshSENames(std::vector< std::pair<std::string,std::string> >& ps) const;
    void blowUpSE(MEDFileMeshes *ms, const MEDFileStructureElements *ses);
    MCAuto<MEDFileFields> partOfThisOnStructureElements() const;
    MCAuto<MEDFileFields> partOfThisLyingOnSpecifiedMeshSEName(const std::string& meshName, const std::string& seName) const;
    void aggregate(const MEDFileFields& other);
    MEDFileFieldsIterator *iterator();
    void destroyFieldAtPos(int i);
    void destroyFieldsAtPos(const int *startIds, const int *endIds);
    void destroyFieldsAtPos2(int bg, int end, int step);
    bool changeMeshNames(const std::vector< std::pair<std::string,std::string> >& modifTab);
    bool renumberEntitiesLyingOnMesh(const std::string& meshName, const std::vector<mcIdType>& oldCode, const std::vector<mcIdType>& newCode, const DataArrayIdType *renumO2N);
    void accept(MEDFileFieldVisitor& visitor) const;
    MCAuto<MEDFileFields> linearToQuadratic(const MEDFileMeshes *oldLin, const MEDFileMeshes *newQuad) const;
  public:
    MEDFileFields *extractPart(const std::map<int, MCAuto<DataArrayIdType> >& extractDef, MEDFileMesh *mm) const;
  public:
    std::vector<std::string> getPflsReallyUsed() const;
    std::vector<std::string> getLocsReallyUsed() const;
    std::vector<std::string> getPflsReallyUsedMulti() const;
    std::vector<std::string> getLocsReallyUsedMulti() const;
    void changePflsRefsNamesGen(const std::vector< std::pair<std::vector<std::string>, std::string > >& mapOfModif);
    void changeLocsRefsNamesGen(const std::vector< std::pair<std::vector<std::string>, std::string > >& mapOfModif);
  private:
    ~MEDFileFields() { }
    MEDFileFields();
    MEDFileFields(med_idt fid, bool loadAll, const MEDFileMeshes *ms, const MEDFileEntities *entities);
  private:
    std::vector< MCAuto<MEDFileAnyTypeFieldMultiTSWithoutSDA> > _fields;
  };

  class MEDFileFieldsIterator
  {
  public:
    MEDLOADER_EXPORT MEDFileFieldsIterator(MEDFileFields *fs);
    MEDLOADER_EXPORT ~MEDFileFieldsIterator();
    MEDLOADER_EXPORT MEDFileAnyTypeFieldMultiTS *nextt();
  private:
    MCAuto<MEDFileFields> _fs;
    int _iter_id;
    int _nb_iter;
  };
}
