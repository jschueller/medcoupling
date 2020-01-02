// Copyright (C) 2007-2019  CEA/DEN, EDF R&D
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

#include "MEDFileMeshElt.hxx"
#include "MEDFileSafeCaller.txx"
#include "MEDFileMeshReadSelector.hxx"
#include "MEDFileBasis.hxx"

#include "MEDCouplingUMesh.hxx"

#include "InterpKernelException.hxx"
#include "InterpKernelAutoPtr.hxx"
#include "CellModel.hxx"

#include <iostream>

extern med_geometry_type typmai3[INTERP_KERNEL::NORM_MAXTYPE];

using namespace MEDCoupling;

MEDFileUMeshPerTypeCommon *MEDFileUMeshPerTypeCommon::New()
{
  return new MEDFileUMeshPerTypeCommon;
}

void MEDFileUMeshPerTypeCommon::loadCommonPart(med_idt fid, const char *mName, int dt, int it, mcIdType curNbOfElem, med_geometry_type geoElt,
                                               med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  _fam=0;
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_FAMILY_NUMBER,MED_NODAL,&changement,&transformation)>0)
    {    
      if(!mrs || mrs->isCellFamilyFieldReading())
        {
          MCAuto<DataArrayMedInt> miFam=DataArrayMedInt::New();
          miFam->alloc(curNbOfElem,1);
          if(MEDmeshEntityFamilyNumberRd(fid,mName,dt,it,entity,geoElt,miFam->getPointer())!=0)
            std::fill(miFam->getPointer(),miFam->getPointer()+curNbOfElem,0);
          _fam=FromMedIntArray<mcIdType>( miFam );
        }
    }
  _num=0;
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_NUMBER,MED_NODAL,&changement,&transformation)>0)
    {
      if(!mrs || mrs->isCellNumFieldReading())
        {
          MCAuto<DataArrayMedInt> miNum=DataArrayMedInt::New();
          miNum->alloc(curNbOfElem,1);
          if(MEDmeshEntityNumberRd(fid,mName,dt,it,entity,geoElt,miNum->getPointer())!=0)
            miNum=0;
          _num=FromMedIntArray<mcIdType>(miNum);
        }
    }
  _names=0;
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_NAME,MED_NODAL,&changement,&transformation)>0)
    {
      if(!mrs || mrs->isCellNameFieldReading())
        {
          _names=DataArrayAsciiChar::New();
          _names->alloc(curNbOfElem+1,MED_SNAME_SIZE);//not a bug to avoid the memory corruption due to last \0 at the end
          if(MEDmeshEntityNameRd(fid,mName,dt,it,entity,geoElt,_names->getPointer())!=0)
            _names=0;
          else
            _names->reAlloc(curNbOfElem);//not a bug to avoid the memory corruption due to last \0 at the end
        }
    }
}

std::size_t MEDFileUMeshPerTypeCommon::getHeapMemorySizeWithoutChildren() const
{
  return 0;
}

std::vector<const BigMemoryObject *> MEDFileUMeshPerTypeCommon::getDirectChildrenWithNull() const
{
  std::vector<const BigMemoryObject *> ret;
  ret.push_back((const DataArrayIdType *)_num);
  ret.push_back((const DataArrayIdType *)_fam);
  ret.push_back((const DataArrayAsciiChar *)_names);
  return ret;
}

MEDFileUMeshPerType *MEDFileUMeshPerType::New(med_idt fid, const char *mName, int dt, int it, int mdim, med_geometry_type geoElt, INTERP_KERNEL::NormalizedCellType geoElt2, MEDFileMeshReadSelector *mrs)
{
  med_entity_type whichEntity;
  if(!isExisting(fid,mName,dt,it,geoElt,whichEntity))
    return 0;
  return new MEDFileUMeshPerType(fid,mName,dt,it,mdim,geoElt,geoElt2,whichEntity,mrs);
}

MEDFileUMeshPerType *MEDFileUMeshPerType::NewPart(med_idt fid, const char *mName, int dt, int it, int mdim, INTERP_KERNEL::NormalizedCellType geoElt2, mcIdType strt, mcIdType stp, mcIdType step, MEDFileMeshReadSelector *mrs)
{
  int geoElt2i((int)geoElt2);
  if(geoElt2i<0 || geoElt2i>=INTERP_KERNEL::NORM_MAXTYPE)
    throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::NewPart : Not recognized MEDCoupling/MEDLoader geometric type !");
  med_geometry_type geoElt(typmai3[geoElt2]);
  med_entity_type whichEntity;
  if(!isExisting(fid,mName,dt,it,geoElt,whichEntity))
    throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::NewPart : The specified geo type is not present in the specified mesh !");
  MCAuto<MEDFileUMeshPerType> ret(new MEDFileUMeshPerType);
  ret->loadPart(fid,mName,dt,it,mdim,geoElt,geoElt2,whichEntity,strt,stp,step,mrs);
  return ret.retn();
}

std::size_t MEDFileUMeshPerType::getHeapMemorySizeWithoutChildren() const
{
  return MEDFileUMeshPerTypeCommon::getHeapMemorySizeWithoutChildren()+0;
}

std::vector<const BigMemoryObject *> MEDFileUMeshPerType::getDirectChildrenWithNull() const
{
  std::vector<const BigMemoryObject *> ret(MEDFileUMeshPerTypeCommon::getDirectChildrenWithNull());
  ret.push_back((const MEDCoupling1GTUMesh *)_m);
  return ret;
}

bool MEDFileUMeshPerType::isExisting(med_idt fid, const char *mName, int dt, int it, med_geometry_type geoElt, med_entity_type& whichEntity)
{
  static const med_entity_type entities[3]={MED_CELL,MED_DESCENDING_FACE,MED_DESCENDING_EDGE};
  mcIdType nbOfElt=0;
  for(int i=0;i<3;i++)
    {
      med_bool changement,transformation;
      mcIdType tmp(MEDmeshnEntity(fid,mName,dt,it,entities[i],geoElt,MED_CONNECTIVITY,MED_NODAL,&changement,&transformation));
      if(tmp>nbOfElt)
        {
          nbOfElt=tmp;
          whichEntity=entities[i];
          if(i>0)
            std::cerr << "WARNING : MEDFile has been detected to be noncompliant with MED 3 : Please change entity in MEDFile for geotype " <<  geoElt << std::endl;
        }
    }
  return nbOfElt>0;
}

int MEDFileUMeshPerType::getDim() const
{
  return _m->getMeshDimension();
}

MEDFileUMeshPerType::MEDFileUMeshPerType()
{
}

MEDFileUMeshPerType::MEDFileUMeshPerType(med_idt fid, const char *mName, int dt, int it, int mdim, med_geometry_type geoElt, INTERP_KERNEL::NormalizedCellType type,
                                         med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  mcIdType curNbOfElem(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_CONNECTIVITY,MED_NODAL,&changement,&transformation));
  const INTERP_KERNEL::CellModel& cm(INTERP_KERNEL::CellModel::GetCellModel(type));
  if(!cm.isDynamic())
    {
      loadFromStaticType(fid,mName,dt,it,mdim,curNbOfElem,geoElt,type,entity,mrs);
      return;
    }
  if(type==INTERP_KERNEL::NORM_POLYGON || type==INTERP_KERNEL::NORM_QPOLYG)
    {
      loadPolyg(fid,mName,dt,it,mdim,curNbOfElem,geoElt,entity,mrs);
      return;
    }
  //if(type==INTERP_KERNEL::NORM_POLYHED)
  loadPolyh(fid,mName,dt,it,mdim,curNbOfElem,geoElt,entity,mrs);
}

void MEDFileUMeshPerType::loadPart(med_idt fid, const char *mName, int dt, int it, int mdim, med_geometry_type geoElt, INTERP_KERNEL::NormalizedCellType type,
                                   med_entity_type entity, mcIdType strt, mcIdType end, mcIdType step, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  mcIdType curNbOfElem(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_CONNECTIVITY,MED_NODAL,&changement,&transformation));
  const INTERP_KERNEL::CellModel& cm(INTERP_KERNEL::CellModel::GetCellModel(type));
  _pd=PartDefinition::New(strt,end,step);
  if(!cm.isDynamic())
    {
      loadPartStaticType(fid,mName,dt,it,mdim,curNbOfElem,geoElt,type,entity,strt,end,step,mrs);
    }
  else
    throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::loadPart : not implemented yet for the dynamic type !");
}

void MEDFileUMeshPerType::loadFromStaticType(med_idt fid, const char *mName, int dt, int it, int mdim, mcIdType curNbOfElem, med_geometry_type geoElt, INTERP_KERNEL::NormalizedCellType type,
                                             med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  _m=MEDCoupling1SGTUMesh::New(mName,type);
  MEDCoupling1SGTUMesh *mc(dynamic_cast<MEDCoupling1SGTUMesh *>((MEDCoupling1GTUMesh *)_m));
  MCAuto<DataArrayMedInt> conn(DataArrayMedInt::New());
  mcIdType nbOfNodesPerCell(mc->getNumberOfNodesPerCell());
  conn->alloc(nbOfNodesPerCell*curNbOfElem,1);
  MEDFILESAFECALLERRD0(MEDmeshElementConnectivityRd,(fid,mName,dt,it,entity,geoElt,MED_NODAL,MED_FULL_INTERLACE,conn->getPointer()));
  std::transform(conn->begin(),conn->end(),conn->getPointer(),std::bind2nd(std::plus<med_int>(),-1));
  mc->setNodalConnectivity(FromMedIntArray<mcIdType>(conn));
  loadCommonPart(fid,mName,dt,it,curNbOfElem,geoElt,entity,mrs);
}

void MEDFileUMeshPerType::loadPartStaticType(med_idt fid, const char *mName, int dt, int it, int mdim, mcIdType curNbOfElem, med_geometry_type geoElt, INTERP_KERNEL::NormalizedCellType type,
                                             med_entity_type entity, mcIdType strt, mcIdType end, mcIdType step, MEDFileMeshReadSelector *mrs)
{
  if(strt<0)
    throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::loadPartStaticType : start pos is negative !");
  if(end>curNbOfElem)
    throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::loadPartStaticType : end is after the authorized range !");
  mcIdType nbOfEltsToLoad(DataArray::GetNumberOfItemGivenBES(strt,end,step,"MEDFileUMeshPerType::loadPartStaticType"));
  _m=MEDCoupling1SGTUMesh::New(mName,type);
  MEDCoupling1SGTUMesh *mc(dynamic_cast<MEDCoupling1SGTUMesh *>((MEDCoupling1GTUMesh *)_m));
  MCAuto<DataArrayMedInt> conn(DataArrayMedInt::New());
  mcIdType nbOfNodesPerCell(mc->getNumberOfNodesPerCell());
  conn->alloc(nbOfNodesPerCell*nbOfEltsToLoad,1);
  med_filter filter=MED_FILTER_INIT;
  MEDfilterBlockOfEntityCr(fid,/*nentity*/ToMedInt(curNbOfElem),/*nvaluesperentity*/1,/*nconstituentpervalue*/ToMedInt(nbOfNodesPerCell),
                           MED_ALL_CONSTITUENT,MED_FULL_INTERLACE,MED_COMPACT_STMODE,MED_NO_PROFILE,
                           /*start*/ToMedInt(strt+1),/*stride*/ToMedInt(step),/*count*/1,/*blocksize*/ToMedInt(nbOfEltsToLoad),
                           /*lastblocksize=useless because count=1*/0,&filter);
  MEDFILESAFECALLERRD0(MEDmeshElementConnectivityAdvancedRd,(fid,mName,dt,it,entity,geoElt,MED_NODAL,&filter,conn->getPointer()));
  MEDfilterClose(&filter);
  std::transform(conn->begin(),conn->end(),conn->getPointer(),std::bind2nd(std::plus<med_int>(),-1));
  mc->setNodalConnectivity(FromMedIntArray<mcIdType>(conn));
  loadPartOfCellCommonPart(fid,mName,strt,end,step,dt,it,mdim,curNbOfElem,geoElt,entity,mrs);
}

void MEDFileUMeshPerType::loadPartOfCellCommonPart(med_idt fid, const char *mName, mcIdType strt, mcIdType stp, mcIdType step, int dt, int it, int mdim, mcIdType curNbOfElem, med_geometry_type geoElt, med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  _fam=0;
  mcIdType nbOfEltsToLoad(DataArray::GetNumberOfItemGivenBES(strt,stp,step,"MEDFileUMeshPerType::loadPartOfCellCommonPart"));
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_FAMILY_NUMBER,MED_NODAL,&changement,&transformation)>0)
    {
      if(!mrs || mrs->isCellFamilyFieldReading())
        {
          MCAuto<DataArrayMedInt> miFam(DataArrayMedInt::New());
          miFam->alloc(nbOfEltsToLoad,1);
          med_filter filter=MED_FILTER_INIT;
          MEDfilterBlockOfEntityCr(fid,/*nentity*/ToMedInt(curNbOfElem),/*nvaluesperentity*/1,/*nconstituentpervalue*/1,
                                   MED_ALL_CONSTITUENT,MED_FULL_INTERLACE,MED_COMPACT_STMODE,MED_NO_PROFILE,
                                   /*start*/ToMedInt(strt+1),/*stride*/ToMedInt(step),/*count*/1,/*blocksize*/ToMedInt(nbOfEltsToLoad),
                                   /*lastblocksize=useless because count=1*/0,&filter);
          if(MEDmeshEntityAttributeAdvancedRd(fid,mName,MED_FAMILY_NUMBER,dt,it,entity,geoElt,&filter,miFam->getPointer())!=0)
            miFam->fillWithZero();
          _fam=FromMedIntArray<mcIdType>(miFam);
          MEDfilterClose(&filter);
        }
    }
  _num=0;
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_NUMBER,MED_NODAL,&changement,&transformation)>0)
    {
      if(!mrs || mrs->isCellNumFieldReading())
        {
          MCAuto<DataArrayMedInt> miNum(DataArrayMedInt::New());
          miNum->alloc(nbOfEltsToLoad,1);
          med_filter filter=MED_FILTER_INIT;
          MEDfilterBlockOfEntityCr(fid,/*nentity*/ToMedInt(curNbOfElem),/*nvaluesperentity*/1,/*nconstituentpervalue*/1,
                                   MED_ALL_CONSTITUENT,MED_FULL_INTERLACE,MED_COMPACT_STMODE,MED_NO_PROFILE,
                                   /*start*/ToMedInt(strt+1),/*stride*/ToMedInt(step),/*count*/1,/*blocksize*/ToMedInt(nbOfEltsToLoad),
                                   /*lastblocksize=useless because count=1*/0,&filter);
          if(MEDmeshEntityAttributeAdvancedRd(fid,mName,MED_NUMBER,dt,it,entity,geoElt,&filter,miNum->getPointer())!=0)
            miNum->fillWithZero();
          _num=FromMedIntArray<mcIdType>(miNum);
          MEDfilterClose(&filter);
        }
    }
  _names=0;
  if(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_NAME,MED_NODAL,&changement,&transformation)>0)
    {
      if(!mrs || mrs->isCellNameFieldReading())
        {
          _names=DataArrayAsciiChar::New();
          _names->alloc(nbOfEltsToLoad+1,MED_SNAME_SIZE);//not a bug to avoid the memory corruption due to last \0 at the end
          med_filter filter=MED_FILTER_INIT;
          MEDfilterBlockOfEntityCr(fid,/*nentity*/ToMedInt(curNbOfElem),/*nvaluesperentity*/1,/*nconstituentpervalue*/1,
                                   MED_ALL_CONSTITUENT,MED_FULL_INTERLACE,MED_COMPACT_STMODE,MED_NO_PROFILE,
                                   /*start*/ToMedInt(strt+1),/*stride*/ToMedInt(step),/*count*/1,/*blocksize*/ToMedInt(nbOfEltsToLoad),
                                   /*lastblocksize=useless because count=1*/0,&filter);
          if(MEDmeshEntityAttributeAdvancedRd(fid,mName,MED_NAME,dt,it,entity,geoElt,&filter,_names->getPointer())!=0)
            _names=0;
          else
            _names->reAlloc(nbOfEltsToLoad);//not a bug to avoid the memory corruption due to last \0 at the end
          MEDfilterClose(&filter);
        }
    }
}

void MEDFileUMeshPerType::loadPolyg(med_idt fid, const char *mName, int dt, int it, int mdim, mcIdType arraySize, med_geometry_type geoElt,
                                    med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  mcIdType curNbOfElem(MEDmeshnEntity(fid,mName,dt,it,entity,geoElt,MED_INDEX_NODE,MED_NODAL,&changement,&transformation)-1);
  _m=MEDCoupling1DGTUMesh::New(mName,geoElt==MED_POLYGON?INTERP_KERNEL::NORM_POLYGON:INTERP_KERNEL::NORM_QPOLYG);
  MCAuto<MEDCoupling1DGTUMesh> mc(DynamicCast<MEDCoupling1GTUMesh,MEDCoupling1DGTUMesh>(_m));
  MCAuto<DataArrayMedInt> conn(DataArrayMedInt::New()),connI(DataArrayMedInt::New());
  conn->alloc(arraySize,1); connI->alloc(curNbOfElem+1,1);
  MEDFILESAFECALLERRD0(MEDmeshPolygon2Rd,(fid,mName,dt,it,MED_CELL,geoElt,MED_NODAL,connI->getPointer(),conn->getPointer()));
  std::transform(conn->begin(),conn->end(),conn->getPointer(),std::bind2nd(std::plus<med_int>(),-1));
  std::transform(connI->begin(),connI->end(),connI->getPointer(),std::bind2nd(std::plus<med_int>(),-1));
  mc->setNodalConnectivity(FromMedIntArray<mcIdType>(conn),FromMedIntArray<mcIdType>(connI));
  loadCommonPart(fid,mName,dt,it,curNbOfElem,geoElt,entity,mrs);
}

void MEDFileUMeshPerType::loadPolyh(med_idt fid, const char *mName, int dt, int it, int mdim, mcIdType connFaceLgth, med_geometry_type geoElt,
                                    med_entity_type entity, MEDFileMeshReadSelector *mrs)
{
  med_bool changement,transformation;
  med_int indexFaceLgth(MEDmeshnEntity(fid,mName,dt,it,MED_CELL,MED_POLYHEDRON,MED_INDEX_NODE,MED_NODAL,&changement,&transformation));
  mcIdType curNbOfElem(MEDmeshnEntity(fid,mName,dt,it,MED_CELL,MED_POLYHEDRON,MED_INDEX_FACE,MED_NODAL,&changement,&transformation)-1);
  _m=MEDCoupling1DGTUMesh::New(mName,INTERP_KERNEL::NORM_POLYHED);
  MCAuto<MEDCoupling1DGTUMesh> mc(DynamicCastSafe<MEDCoupling1GTUMesh,MEDCoupling1DGTUMesh>(_m));
  INTERP_KERNEL::AutoPtr<med_int> index=new med_int[curNbOfElem+1];
  INTERP_KERNEL::AutoPtr<med_int> indexFace=new med_int[indexFaceLgth];
  INTERP_KERNEL::AutoPtr<med_int> locConn=new med_int[connFaceLgth];
  MEDFILESAFECALLERRD0(MEDmeshPolyhedronRd,(fid,mName,dt,it,MED_CELL,MED_NODAL,index,indexFace,locConn));
  MCAuto<DataArrayIdType> conn(DataArrayIdType::New()),connI(DataArrayIdType::New());
  mcIdType arraySize=connFaceLgth;
  for(mcIdType i=0;i<curNbOfElem;i++)
    arraySize+=index[i+1]-index[i]-1;
  conn=DataArrayIdType::New();
  conn->alloc(arraySize,1);
  mcIdType *wFinalConn=conn->getPointer();
  connI->alloc(curNbOfElem+1,1);
  mcIdType *finalIndex(connI->getPointer());
  finalIndex[0]=0;
  for(mcIdType i=0;i<curNbOfElem;i++)
    {
      finalIndex[i+1]=finalIndex[i]+index[i+1]-index[i]-1+indexFace[index[i+1]-1]-indexFace[index[i]-1];
      wFinalConn=std::transform(locConn+indexFace[index[i]-1]-1,locConn+indexFace[index[i]]-1,wFinalConn,std::bind2nd(std::plus<mcIdType>(),-1));
      for(mcIdType j=index[i];j<index[i+1]-1;j++)
        {
          *wFinalConn++=-1;
          wFinalConn=std::transform(locConn+indexFace[j]-1,locConn+indexFace[j+1]-1,wFinalConn,std::bind2nd(std::plus<mcIdType>(),-1));
        }
    }
  mc->setNodalConnectivity(conn,connI);
  loadCommonPart(fid,mName,dt,it,curNbOfElem,MED_POLYHEDRON,entity,mrs);
}

void MEDFileUMeshPerType::Write(med_idt fid, const std::string& mname, int mdim, const MEDCoupling1GTUMesh *m, const DataArrayIdType *fam, const DataArrayIdType *num, const DataArrayAsciiChar *names)
{
  mcIdType nbOfCells=m->getNumberOfCells();
  if(nbOfCells<1)
    return ;
  int dt,it;
  double timm=m->getTime(dt,it);
  INTERP_KERNEL::NormalizedCellType ikt=m->getTypeOfCell(0);
  const INTERP_KERNEL::CellModel& cm=INTERP_KERNEL::CellModel::GetCellModel(ikt);
  med_geometry_type curMedType=typmai3[(int)ikt];
  if(!cm.isDynamic())
    {
      const MEDCoupling1SGTUMesh *m0(dynamic_cast<const MEDCoupling1SGTUMesh *>(m));
      if(!m0)
        throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::Write : internal error #1 !");
      MCAuto<DataArrayMedInt> arr(DataArrayMedInt::Copy(m0->getNodalConnectivity()));
      std::transform(arr->begin(),arr->end(),arr->getPointer(),std::bind2nd(std::plus<med_int>(),1));
      MEDFILESAFECALLERWR0(MEDmeshElementConnectivityWr,(fid,mname.c_str(),dt,it,timm,MED_CELL,curMedType,MED_NODAL,MED_FULL_INTERLACE,ToMedInt(nbOfCells),arr->begin()));
    }
  else
    {
      const MEDCoupling1DGTUMesh *m0(dynamic_cast<const MEDCoupling1DGTUMesh *>(m));
      if(!m0)
        throw INTERP_KERNEL::Exception("MEDFileUMeshPerType::Write : internal error #2 !");
      if(ikt==INTERP_KERNEL::NORM_POLYGON || ikt==INTERP_KERNEL::NORM_QPOLYG)
        {
          MCAuto<DataArrayMedInt> arr(DataArrayMedInt::Copy(m0->getNodalConnectivity())),arrI(DataArrayMedInt::Copy(m0->getNodalConnectivityIndex()));
          std::transform(arr->begin(),arr->end(),arr->getPointer(),std::bind2nd(std::plus<med_int>(),1));
          std::transform(arrI->begin(),arrI->end(),arrI->getPointer(),std::bind2nd(std::plus<med_int>(),1));
          MEDFILESAFECALLERWR0(MEDmeshPolygon2Wr,(fid,mname.c_str(),dt,it,timm,MED_CELL,ikt==INTERP_KERNEL::NORM_POLYGON?MED_POLYGON:MED_POLYGON2,MED_NODAL,ToMedInt(nbOfCells+1),arrI->begin(),arr->begin()));
        }
      else
        {
          const mcIdType *conn(m0->getNodalConnectivity()->begin()),*connI(m0->getNodalConnectivityIndex()->begin());
          mcIdType meshLgth=m0->getNodalConnectivityLength();
          mcIdType nbOfFaces=ToIdType(std::count(conn,conn+meshLgth,-1)+nbOfCells);
          INTERP_KERNEL::AutoPtr<med_int> tab1=new med_int[nbOfCells+1];
          med_int *w1=tab1; *w1=1;
          INTERP_KERNEL::AutoPtr<med_int> tab2=new med_int[nbOfFaces+1];
          med_int *w2=tab2; *w2=1;
          INTERP_KERNEL::AutoPtr<med_int> bigtab=new med_int[meshLgth];
          med_int *bt=bigtab;
          for(mcIdType i=0;i<nbOfCells;i++,w1++)
            {
              int nbOfFaces2=0;
              for(const mcIdType *w=conn+connI[i];w!=conn+connI[i+1];w2++)
                {
                  const mcIdType *wend=std::find(w,conn+connI[i+1],-1);
                  bt=std::transform(w,wend,bt,std::bind2nd(std::plus<mcIdType>(),1));
                  std::size_t nbOfNode=std::distance(w,wend);
                  w2[1]=w2[0]+(med_int)nbOfNode;
                  if(wend!=conn+connI[i+1])
                    w=wend+1;
                  else
                    w=wend;
                  nbOfFaces2++;
                }
              w1[1]=w1[0]+nbOfFaces2;
            }
          MEDFILESAFECALLERWR0(MEDmeshPolyhedronWr,(fid,mname.c_str(),dt,it,timm,MED_CELL,MED_NODAL,ToMedInt(nbOfCells+1),tab1,ToMedInt(nbOfFaces+1),tab2,bigtab));
        }
    }
  if(fam)
    MEDFILESAFECALLERWR0(MEDmeshEntityFamilyNumberWr,(fid,mname.c_str(),dt,it,MED_CELL,curMedType,ToMedInt(nbOfCells),ToMedIntArray<mcIdType>(fam)->getConstPointer()));
  if(num)
    MEDFILESAFECALLERWR0(MEDmeshEntityNumberWr,(fid,mname.c_str(),dt,it,MED_CELL,curMedType,ToMedInt(nbOfCells),ToMedIntArray<mcIdType>(num)->getConstPointer()));
  if(names)
    {
      if(names->getNumberOfComponents()!=MED_SNAME_SIZE)
        {
          std::ostringstream oss; oss << "MEDFileUMeshPerType::write : expected a name field on cells with number of components set to " << MED_SNAME_SIZE;
          oss << " ! The array has " << names->getNumberOfComponents() << " components !";
          throw INTERP_KERNEL::Exception(oss.str().c_str());
        }
      MEDFILESAFECALLERWR0(MEDmeshEntityNameWr,(fid,mname.c_str(),dt,it,MED_CELL,curMedType,ToMedInt(nbOfCells),names->getConstPointer()));
    }
}
