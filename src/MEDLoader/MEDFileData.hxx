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

#ifndef __MEDFILEDATA_HXX__
#define __MEDFILEDATA_HXX__

#include "MCAuto.hxx"
#include "MEDFileParameter.hxx"
#include "MEDFileField.hxx"
#include "MEDFileMesh.hxx"
#include "MEDFileMeshSupport.hxx"
#include "MEDFileStructureElement.hxx"

namespace MEDCoupling
{
  /*!
   * User class.
   */
  class MEDLOADER_EXPORT MEDFileData : public RefCountObject, public MEDFileWritableStandAlone
  {
  public:
    static MEDFileData *New(const std::string& fileName);
    static MEDFileData *New(med_idt fid);
    static MEDFileData *New();
    static MEDFileData *New(DataArrayByte *db) { return BuildFromMemoryChunk<MEDFileData>(db); }
    std::string getClassName() const override { return std::string("MEDFileData"); }
    MEDFileData *deepCopy() const;
    std::size_t getHeapMemorySizeWithoutChildren() const;
    std::vector<const BigMemoryObject *> getDirectChildrenWithNull() const;
    MEDFileFields *getFields() const;
    MEDFileMeshes *getMeshes() const;
    MEDFileParameters *getParams() const;
    void setFields(MEDFileFields *fields);
    void setMeshes(MEDFileMeshes *meshes);
    void setParams(MEDFileParameters *params);
    int getNumberOfFields() const;
    int getNumberOfMeshes() const;
    int getNumberOfParams() const;
    std::string simpleRepr() const;
    //
    std::string getHeader() const;
    void setHeader(const std::string& header);
    //
    bool changeMeshNames(const std::vector< std::pair<std::string,std::string> >& modifTab);
    bool changeMeshName(const std::string& oldMeshName, const std::string& newMeshName);
    bool unPolyzeMeshes();
    void dealWithStructureElements();
    static MCAuto<MEDFileData> Aggregate(const std::vector<const MEDFileData *>& mfds);
    //
    void writeLL(med_idt fid) const;
  private:
    MEDFileData();
    MEDFileData(med_idt fid);
    void readHeader(med_idt fid);
    void writeHeader(med_idt fid) const;
    void readMeshSupports(med_idt fid);
  private:
    MCAuto<MEDFileFields> _fields;
    MCAuto<MEDFileMeshes> _meshes;
    MCAuto<MEDFileParameters> _params;
    MCAuto<MEDFileMeshSupports> _mesh_supports;
    MCAuto<MEDFileStructureElements> _struct_elems;
    std::string _header;
  };
}

#endif
