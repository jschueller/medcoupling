#  -*- coding: utf-8 -*-
# Copyright (C) 2007-2020  CEA/DEN,EDF R&D
#
# This library is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License,or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with this library; if not,write to the Free Software
# Foundation,Inc.,59 Temple Place,Suite 330,Boston,MA  02111-1307 USA
#
# See http://www.salome-platform.org/ or email : webmaster.salome@opencascade.com
#


import sys
if sys.platform == "win32":
    from MEDCouplingCompat import *
else:
    from medcoupling import *
import unittest
from math import pi,e,sqrt,cos,sin
from datetime import datetime
from MEDCouplingDataForTest import MEDCouplingDataForTest
import rlcompleter,readline # this line has to be here,to ensure a usability of MEDCoupling/MEDLoader. B4 removing it please notify to anthony.geay@cea.fr

class MEDCouplingBasicsTest7(unittest.TestCase):

    def testDAIGetIdsEqual1(self):
        tab1=[5,-2,-4,-2,3,2,-2];
        da=DataArrayInt64.New();
        da.setValues(tab1,7,1);
        da2=da.findIdsEqual(-2);
        self.assertEqual(3,da2.getNumberOfTuples());
        self.assertEqual(1,da2.getNumberOfComponents());
        expected1=[1,3,6];
        self.assertEqual(expected1,da2.getValues());
        pass

    def testDAIGetIdsEqualList1(self):
        tab1=[5,-2,-4,-2,3,2,-2];
        da=DataArrayInt64.New();
        da.setValues(tab1,7,1);
        da2=da.findIdsEqualList([3,-2,0]);
        self.assertEqual(4,da2.getNumberOfTuples());
        self.assertEqual(1,da2.getNumberOfComponents());
        expected1=[1,3,4,6];
        self.assertEqual(expected1,da2.getValues());
        pass

    def testDAIsUniform1(self):
        tab1=[1,1,1,1,1]
        da=DataArrayInt64.New();
        da.setValues(tab1,5,1);
        self.assertTrue(da.isUniform(1));
        da.setIJ(2,0,2);
        self.assertTrue(not da.isUniform(1));
        da.setIJ(2,0,1);
        self.assertTrue(da.isUniform(1));
        da2=da.convertToDblArr();
        self.assertTrue(da2.isUniform(1.,1.e-12));
        da2.setIJ(1,0,1.+1.e-13);
        self.assertTrue(da2.isUniform(1.,1.e-12));
        da2.setIJ(1,0,1.+1.e-11);
        self.assertTrue(not da2.isUniform(1.,1.e-12));
        pass

    def testDAIBuildComplement1(self):
        a=DataArrayInt64.New();
        tab=[3,1,7,8]
        a.setValues(tab,4,1);
        b=a.buildComplement(12);
        self.assertEqual(8,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[0,2,4,5,6,9,10,11]
        for i in range(8):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        pass

    def testDAIBuildUnion1(self):
        a=DataArrayInt64.New();
        tab1=[3,1,7,8]
        a.setValues(tab1,4,1);
        c=DataArrayInt64.New();
        tab2=[5,3,0,18,8]
        c.setValues(tab2,5,1);
        b=a.buildUnion(c);
        self.assertEqual(7,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[0,1,3,5,7,8,18]
        for i in range(7):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        b=DataArrayInt64.BuildUnion([a,c]);
        self.assertEqual(7,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[0,1,3,5,7,8,18]
        for i in range(7):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        pass

    def testDAIBuildIntersection1(self):
        a=DataArrayInt64.New();
        tab1=[3,1,7,8]
        a.setValues(tab1,4,1);
        c=DataArrayInt64.New();
        tab2=[5,3,0,18,8]
        c.setValues(tab2,5,1);
        b=a.buildIntersection(c);
        self.assertEqual(2,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[3,8]
        for i in range(2):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        b=DataArrayInt64.BuildIntersection([a,c]);
        self.assertEqual(2,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[3,8]
        for i in range(2):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        pass

    def testDAIDeltaShiftIndex1(self):
        a=DataArrayInt64.New();
        tab=[1,3,6,7,7,9,15]
        a.setValues(tab,7,1);
        b=a.deltaShiftIndex();
        self.assertEqual(6,b.getNumberOfTuples());
        self.assertEqual(1,b.getNumberOfComponents());
        expected1=[2,3,1,0,2,6]
        for i in range(6):
            self.assertEqual(expected1[i],b.getIJ(0,i));
            pass
        pass

    def testDAIBuildSubstraction1(self):
        a=DataArrayInt64.New()
        aa=[2,3,6,8,9]
        a.setValues(aa,5,1)
        b=DataArrayInt64.New()
        bb=[1,3,5,9,11]
        b.setValues(bb,5,1)
        self.assertEqual([2,6,8],a.buildSubstraction(b).getValues())
        pass

    def testDAIBuildPermutationArr1(self):
        a=DataArrayInt64.New()
        a.setValues([4,5,6,7,8],5,1)
        b=DataArrayInt64.New()
        b.setValues([5,4,8,6,7],5,1)
        c=a.buildPermutationArr(b)
        self.assertEqual([1,0,4,2,3],c.getValues())
        self.assertTrue(a.isEqualWithoutConsideringStrAndOrder(b))
        b.setIJ(0,0,9)
        self.assertTrue(not a.isEqualWithoutConsideringStrAndOrder(b))
        self.assertRaises(InterpKernelException,a.buildPermutationArr,b)
        a.setIJ(3,0,4)
        b.setIJ(0,0,5)
        b.setIJ(4,0,4)#a==[4,5,6,4,8] and b==[5,4,8,6,4]
        self.assertTrue(a.isEqualWithoutConsideringStrAndOrder(b))
        c=a.buildPermutationArr(b)
        self.assertEqual([1,3,4,2,3],c.getValues())
        d=b.convertToDblArr()
        expect3=[4,4,5,6,8]
        b.sort()
        self.assertEqual(expect3,b.getValues())
        d.sort()
        self.assertEqual(5,d.getNumberOfTuples());
        self.assertEqual(1,d.getNumberOfComponents());
        for i in range(5):
            self.assertAlmostEqual(float(expect3[i]),d.getIJ(i,0),14);
            pass
        pass

    def testDAIAggregateMulti1(self):
        a=DataArrayInt64.New()
        a.setValues(list(range(4)),2, 2)
        a.setName("aa")
        b=DataArrayInt64.New()
        b.setValues(list(range(6)), 3, 2)
        c=DataArrayInt64.Aggregate([a,b])
        self.assertEqual(list(range(4)) + list(range(6)), c.getValues())
        self.assertEqual("aa",c.getName())
        self.assertEqual(5,c.getNumberOfTuples())
        self.assertEqual(2,c.getNumberOfComponents())
        pass

    def testDAICheckAndPreparePermutation1(self):
        vals1=[9,10,0,6,4,11,3,7];
        expect1=[5,6,0,3,2,7,1,4];
        vals2=[9,10,0,6,10,11,3,7];
        da=DataArrayInt64.New();
        da.setValues(vals1,8,1);
        da2=da.checkAndPreparePermutation();
        self.assertEqual(8,da2.getNumberOfTuples());
        self.assertEqual(1,da2.getNumberOfComponents());
        for i in range(8):
            self.assertEqual(expect1[i],da2.getIJ(i,0));
            pass
        #
        da=DataArrayInt64.New();
        da.alloc(8,1);
        da.iota(0);
        da2=da.checkAndPreparePermutation();
        self.assertEqual(1,da2.getNumberOfComponents());
        self.assertTrue(da2.isIota(8));
        #
        da=DataArrayInt64.New();
        da.alloc(8,1);
        da.setValues(vals2,8,1);
        self.assertRaises(InterpKernelException,da.checkAndPreparePermutation);
        pass

    def testDAIChangeSurjectiveFormat1(self):
        vals1=[0,3,2,3,2,2,1,2]
        expected1=[0,1,2,6,8]
        expected2=[0,  6,  2,4,5,7,  1,3]
        da=DataArrayInt64.New();
        da.setValues(vals1,8,1);
        #
        da2,da2I=da.changeSurjectiveFormat(4);
        self.assertEqual(5,da2I.getNumberOfTuples());
        self.assertEqual(8,da2.getNumberOfTuples());
        self.assertEqual(expected1,da2I.getValues());
        self.assertEqual(expected2,da2.getValues());
        #
        self.assertRaises(InterpKernelException,da.changeSurjectiveFormat,3);
        #
        pass

    def testDAIGetIdsNotEqual1(self):
        d=DataArrayInt64.New();
        vals1=[2,3,5,6,8,5,5,6,1,-5]
        d.setValues(vals1,10,1);
        d2=d.findIdsNotEqual(5);
        self.assertEqual(7,d2.getNumberOfTuples());
        self.assertEqual(1,d2.getNumberOfComponents());
        expected1=[0,1,3,4,7,8,9]
        for i in range(7):
            self.assertEqual(expected1[i],d2.getIJ(0,i));
            pass
        d.rearrange(2);
        self.assertRaises(InterpKernelException,d.findIdsNotEqual,5);
        vals2=[-4,5,6]
        vals3=vals2;
        d.rearrange(1);
        d3=d.findIdsNotEqualList(vals3);
        self.assertEqual(5,d3.getNumberOfTuples());
        self.assertEqual(1,d3.getNumberOfComponents());
        expected2=[0,1,4,8,9]
        for i in range(5):
            self.assertEqual(expected2[i],d3.getIJ(0,i));
            pass
        pass

    def testDAIComputeOffsets1(self):
        d=DataArrayInt64.New();
        vals1=[3,5,1,2,0,8]
        expected1=[0,3,8,9,11,11]
        d.setValues(vals1,6,1);
        d.computeOffsets();
        self.assertEqual(6,d.getNumberOfTuples());
        self.assertEqual(1,d.getNumberOfComponents());
        for i in range(6):
            self.assertEqual(expected1[i],d.getIJ(0,i));
            pass
        pass

    def testDAITransformWithIndArr1(self):
        if not MEDCouplingUse64BitIDs():
            return
        tab1=[17,18,22,19]
        tab2=[0,1,1,3,3,0,1,3,2,2,3,0]
        expected=[17,18,18,19,19,17,18,19,22,22,19,17]
        d=DataArrayInt64.New();
        d.setValues(tab1,4,1);
        d1=DataArrayInt64.New();
        d1.setValues(tab2,12,1);
        d2=d1[:]
        #
        d1.transformWithIndArr(d);
        self.assertEqual(12,d1.getNumberOfTuples());
        self.assertEqual(1,d1.getNumberOfComponents());
        for i in range(12):
            self.assertEqual(expected[i],d1.getIJ(i,0));
            pass
        #
        d1=d2
        d1.transformWithIndArr(tab1)
        self.assertEqual(12,d1.getNumberOfTuples());
        self.assertEqual(1,d1.getNumberOfComponents());
        for i in range(12):
            self.assertEqual(expected[i],d1.getIJ(i,0));
            pass
        pass

    def testDAIBuildPermArrPerLevel1(self):
        arr=[2,0,1,1,0,1,2,0,1,1,0,0]
        expected1=[10,0,5,6,1,7,11,2,8,9,3,4]
        da=DataArrayInt64.New();
        da.setValues(arr,12,1);
        da2=da.buildPermArrPerLevel();
        self.assertEqual(12,da2.getNumberOfTuples());
        self.assertEqual(1,da2.getNumberOfComponents());
        for i in range(12):
            self.assertEqual(expected1[i],da2.getIJ(i,0));
            pass
        pass

    def testDAIOperations1(self):
        arr1=[-1,-2,4,7,3,2,6,6,4,3,0,1]
        da=DataArrayInt64.New();
        da.setValues(arr1,4,3);
        da1=DataArrayInt64.New();
        da1.alloc(12,1);
        da1.iota(2);
        self.assertRaises(InterpKernelException,DataArrayInt64.Add,da,da1);#not same number of tuples/Components
        da1.rearrange(3);
        da2=DataArrayInt64.Add(da,da1);
        self.assertEqual(4,da2.getNumberOfTuples());
        self.assertEqual(3,da2.getNumberOfComponents());
        expected1=[1,1,8,12,9,9,14,15,14,14,12,14]
        for i in range(12):
            self.assertEqual(expected1[i],da2.getIJ(0,i));
            pass
        da1.substractEqual(da);
        expected2=[3,5,0,-2,3,5,2,3,6,8,12,12]
        for i in range(12):
            self.assertEqual(expected2[i],da1.getIJ(0,i));
            pass
        da1.rearrange(1); da1.iota(2); da1.rearrange(3);
        da1.addEqual(da);
        for i in range(12):
            self.assertEqual(expected1[i],da1.getIJ(0,i));
            pass
        da1.rearrange(1); da1.iota(2); da1.rearrange(3);
        da2=DataArrayInt64.Multiply(da,da1);
        self.assertEqual(4,da2.getNumberOfTuples());
        self.assertEqual(3,da2.getNumberOfComponents());
        expected3=[-2,-6,16,35,18,14,48,54,40,33,0,13]
        for i in range(12):
            self.assertEqual(expected3[i],da2.getIJ(0,i));
            pass
        da.divideEqual(da1);
        self.assertEqual(4,da.getNumberOfTuples());
        self.assertEqual(3,da.getNumberOfComponents());
        expected4=[0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
        for i in range(12):
            self.assertEqual(expected4[i],da.getIJ(0,i));
            pass
        da.setValues(arr1,4,3);
        da1.multiplyEqual(da);
        self.assertEqual(4,da1.getNumberOfTuples());
        self.assertEqual(3,da1.getNumberOfComponents());
        for i in range(12):
            self.assertEqual(expected3[i],da1.getIJ(0,i));
            pass
        da1.rearrange(1); da1.iota(2); da1.rearrange(3);
        da2=DataArrayInt64.Divide(da,da1);
        self.assertEqual(4,da2.getNumberOfTuples());
        self.assertEqual(3,da2.getNumberOfComponents());
        for i in range(12):
            self.assertEqual(expected4[i],da2.getIJ(0,i));
            pass
        da1.applyInv(321);
        self.assertEqual(4,da1.getNumberOfTuples());
        self.assertEqual(3,da1.getNumberOfComponents());
        expected5=[160,107,80,64,53,45,40,35,32,29,26,24]
        for i in range(12):
            self.assertEqual(expected5[i],da1.getIJ(0,i));
            pass
        da1.applyDivideBy(2);
        self.assertEqual(4,da1.getNumberOfTuples());
        self.assertEqual(3,da1.getNumberOfComponents());
        expected6=[80,53,40,32,26,22,20,17,16,14,13,12]
        for i in range(12):
            self.assertEqual(expected6[i],da1.getIJ(0,i));
            pass
        expected7=[3,4,5,4,5,1,6,3,2,0,6,5]
        da1.applyModulus(7);
        for i in range(12):
            self.assertEqual(expected7[i],da1.getIJ(0,i));
            pass
        da1.applyLin(1,1);
        expected8=[3,3,3,3,3,1,3,3,0,0,3,3]
        da1.applyRModulus(3);
        for i in range(12):
            self.assertEqual(expected8[i],da1.getIJ(0,i));
            pass
        pass

    def testDAITransformWithIndArrR1(self):
        tab1=[2,4,5,3,6,7]
        tab2=[-1,-1,0,1,2,3,4,5,-1,-1,-1,-1]
        expected=[0,3,1,2,4,5]
        d=DataArrayInt64.New();
        d.setValues(tab1,6,1);
        d1=DataArrayInt64.New();
        d1.setValues(tab2,12,1);
        d2=d1[:]
        #
        d3=d.transformWithIndArrR(d1);
        self.assertEqual(6,d3.getNumberOfTuples());
        self.assertEqual(1,d3.getNumberOfComponents());
        for i in range(6):
            self.assertEqual(expected[i],d3.getIJ(i,0));
            pass
        #
        d1=d2
        d3=d.transformWithIndArrR(tab2)
        self.assertEqual(6,d3.getNumberOfTuples());
        self.assertEqual(1,d3.getNumberOfComponents());
        for i in range(6):
            self.assertEqual(expected[i],d3.getIJ(i,0));
            pass
        pass

    def testDAISplitByValueRange1(self):
        val1=[6,5,0,3,2,7,8,1,4]
        val2=[0,4,9]
        d=DataArrayInt64.New();
        d.setValues(val1,9,1);
        e,f,g=d.splitByValueRange(val2);
        self.assertEqual(9,e.getNumberOfTuples());
        self.assertEqual(1,e.getNumberOfComponents());
        self.assertEqual(9,f.getNumberOfTuples());
        self.assertEqual(1,f.getNumberOfComponents());
        self.assertEqual(2,g.getNumberOfTuples());
        self.assertEqual(1,g.getNumberOfComponents());
        #
        expected1=[1,1,0,0,0,1,1,0,1]
        expected2=[2,1,0,3,2,3,4,1,0]
        for i in range(9):
            self.assertEqual(expected1[i],e.getIJ(i,0));
            self.assertEqual(expected2[i],f.getIJ(i,0));
            pass
        self.assertEqual(0,g.getIJ(0,0));
        self.assertEqual(1,g.getIJ(1,0));
        #
        d.setIJ(6,0,9);
        self.assertRaises(InterpKernelException,d.splitByValueRange,val2);
        # non regression test in python wrapping
        rg=DataArrayInt64([0,10,29,56,75,102,121,148,167,194,213,240,259,286,305,332,351,378,397,424,443,470,489,516])
        a,b,c=DataArrayInt64([75]).splitByValueRange(rg)
        assert(a.isEqual(DataArrayInt64([4])))
        assert(b.isEqual(DataArrayInt64([0])))
        assert(c.isEqual(DataArrayInt64([4])))
        pass

    def testDAIBuildExplicitArrByRanges1(self):
        d=DataArrayInt64.New();
        vals1=[0,2,3]
        d.setValues(vals1,3,1);
        e=DataArrayInt64.New();
        vals2=[0,3,6,10,14,20]
        e.setValues(vals2,6,1);
        #
        f=d.buildExplicitArrByRanges(e);
        self.assertEqual(11,f.getNumberOfTuples());
        self.assertEqual(1,f.getNumberOfComponents());
        expected1=[0,1,2,6,7,8,9,10,11,12,13]
        for i in range(11):
            self.assertEqual(expected1[i],f.getIJ(i,0));
            pass
        pass

    def testDAIComputeOffsets2(self):
        d=DataArrayInt64.New();
        vals1=[3,5,1,2,0,8]
        expected1=[0,3,8,9,11,11,19]
        d.setValues(vals1,6,1);
        d.computeOffsetsFull();
        self.assertEqual(7,d.getNumberOfTuples());
        self.assertEqual(1,d.getNumberOfComponents());
        for i in range(7):
            self.assertEqual(expected1[i],d.getIJ(0,i));
            pass
        pass

    def testDAIBuildOld2NewArrayFromSurjectiveFormat2(self):
        arr=[0,3, 5,7,9]
        arrI=[0,2,5]
        a=DataArrayInt.New();
        a.setValues(arr,5,1);
        b=DataArrayInt.New();
        b.setValues(arrI,3,1);
        ret,newNbTuple=DataArrayInt64.ConvertIndexArrayToO2N(10,a,b);
        expected=[0,1,2,0,3,4,5,4,6,4]
        self.assertEqual(10,ret.getNbOfElems());
        self.assertEqual(7,newNbTuple);
        self.assertEqual(1,ret.getNumberOfComponents());
        self.assertEqual(expected,ret.getValues());
        self.assertRaises(InterpKernelException,DataArrayInt64.ConvertIndexArrayToO2N,9,a,b);
        pass

    def testDAIBuildUnique1(self):
        d=DataArrayInt64([1,2,2,3,3,3,3,4,5,5,7,7,7,19])
        e=d.buildUnique()
        self.assertTrue(e.isEqual(DataArrayInt64([1,2,3,4,5,7,19])))
        pass

    def testDAIPartitionByDifferentValues1(self):
        d=DataArrayInt64([1,0,1,2,0,2,2,-3,2])
        expected=[[-3,[7]],[0,[1,4]],[1,[0,2]],[2,[3,5,6,8]]]
        for i,elt in enumerate(zip(*d.partitionByDifferentValues())):
            self.assertEqual(expected[i][0],elt[1])
            self.assertEqual(expected[i][1],elt[0].getValues())
            pass
        pass

    def testDAICheckMonotonic1(self):
        data1=[-1,0,2,2,4,5]
        data2=[6,2,0,-8,-9,-56]
        data3=[-1,0,3,2,4,6]
        data4=[7,5,2,3,0,-6]
        d=DataArrayInt64.New(data1);
        self.assertTrue(d.isMonotonic(True));
        self.assertTrue(not d.isMonotonic(False));
        d.checkMonotonic(True);
        self.assertRaises(InterpKernelException,d.checkMonotonic,False)
        d=DataArrayInt64.New(data2);
        self.assertTrue(d.isMonotonic(False));
        self.assertTrue(not d.isMonotonic(True));
        d.checkMonotonic(False);
        self.assertRaises(InterpKernelException,d.checkMonotonic,True)
        d=DataArrayInt64.New(data3);
        self.assertTrue(not d.isMonotonic(False));
        self.assertTrue(not d.isMonotonic(True));
        self.assertRaises(InterpKernelException,d.checkMonotonic,True)
        self.assertRaises(InterpKernelException,d.checkMonotonic,False)
        d=DataArrayInt64.New(data4);
        self.assertTrue(not d.isMonotonic(False));
        self.assertTrue(not d.isMonotonic(True));
        self.assertRaises(InterpKernelException,d.checkMonotonic,True)
        self.assertRaises(InterpKernelException,d.checkMonotonic,False)
        d=DataArrayInt64.New(0,1)
        self.assertTrue(d.isMonotonic(True));
        self.assertTrue(d.isMonotonic(False));
        d.checkMonotonic(True);
        d.checkMonotonic(False);
        d=DataArrayInt64.New(data4,3,2);#throw because nbComp!=1
        self.assertRaises(InterpKernelException,d.isMonotonic,True)
        self.assertRaises(InterpKernelException,d.isMonotonic,False)
        self.assertRaises(InterpKernelException,d.checkMonotonic,True)
        self.assertRaises(InterpKernelException,d.checkMonotonic,False)
        pass

    def testDAIBuildSubstractionOptimized1(self):
        da1=DataArrayInt64.New([1,3,5,6,7,9,13])
        da2=DataArrayInt64.New([3,5,9])
        da3=DataArrayInt64.New([1,3,5])
        da4=DataArrayInt64.New([1,3,5,6,7,9,13])
        #
        a=da1.buildSubstractionOptimized(da2);
        self.assertTrue(a.isEqual(DataArrayInt64([1,6,7,13])));
        #
        a=da1.buildSubstractionOptimized(da3);
        self.assertTrue(a.isEqual(DataArrayInt64([6,7,9,13])));
        #
        a=da1.buildSubstractionOptimized(da4);
        self.assertTrue(a.isEqual(DataArrayInt64([])));
        pass

    def testDAIIsStrictlyMonotonic1(self):
        da1=DataArrayInt64.New([1,3,5,6,7,9,13])
        self.assertTrue(da1.isStrictlyMonotonic(True));
        da1.checkStrictlyMonotonic(True);
        self.assertTrue(da1.isMonotonic(True));
        da1.checkMonotonic(True);
        self.assertTrue(not da1.isStrictlyMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,False)
        self.assertTrue(not da1.isMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,False)
        #
        da1=DataArrayInt64.New([1,3,5,6,6,9,13])
        self.assertTrue(not da1.isStrictlyMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,True)
        self.assertTrue(da1.isMonotonic(True));
        da1.checkMonotonic(True);
        self.assertTrue(not da1.isStrictlyMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,False)
        self.assertTrue(not da1.isMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,False)
        #
        da1=DataArrayInt64.New([1,3,5,6,5,9,13])
        self.assertTrue(not da1.isStrictlyMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,True)
        self.assertTrue(not da1.isMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,True)
        self.assertTrue(not da1.isStrictlyMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,False)
        self.assertTrue(not da1.isMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,False)
        #
        da1=DataArrayInt64.New([13,9,7,6,5,3,1])
        self.assertTrue(not da1.isStrictlyMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,True)
        self.assertTrue(not da1.isMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,True)
        self.assertTrue(da1.isStrictlyMonotonic(False));
        da1.checkStrictlyMonotonic(False);
        self.assertTrue(da1.isMonotonic(False));
        da1.checkMonotonic(False);
        #
        da1=DataArrayInt64.New([13,9,6,6,5,3,1])
        self.assertTrue(not da1.isStrictlyMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,True)
        self.assertTrue(not da1.isMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,True)
        self.assertTrue(not da1.isStrictlyMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,False)
        self.assertTrue(da1.isMonotonic(False));
        da1.checkMonotonic(False);
        #
        da1=DataArrayInt64.New([13,9,5,6,5,3,1])
        self.assertTrue(not da1.isStrictlyMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,True)
        self.assertTrue(not da1.isMonotonic(True));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,True)
        self.assertTrue(not da1.isStrictlyMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkStrictlyMonotonic,False)
        self.assertTrue(not da1.isMonotonic(False));
        self.assertRaises(InterpKernelException,da1.checkMonotonic,False)
        #
        da1=DataArrayInt64.New([])
        self.assertTrue(da1.isStrictlyMonotonic(True));
        da1.checkStrictlyMonotonic(True);
        self.assertTrue(da1.isMonotonic(True));
        da1.checkMonotonic(True);
        self.assertTrue(da1.isStrictlyMonotonic(False));
        da1.checkStrictlyMonotonic(False);
        self.assertTrue(da1.isMonotonic(False));
        da1.checkMonotonic(False);
        #
        da1=DataArrayInt64.New([13])
        self.assertTrue(da1.isStrictlyMonotonic(True));
        da1.checkStrictlyMonotonic(True);
        self.assertTrue(da1.isMonotonic(True));
        da1.checkMonotonic(True);
        self.assertTrue(da1.isStrictlyMonotonic(False));
        da1.checkStrictlyMonotonic(False);
        self.assertTrue(da1.isMonotonic(False));
        da1.checkMonotonic(False);
        pass

    def testDAIIndicesOfSubPart(self):
        a=DataArrayInt64([9,10,0,6,4,11,3,8])
        b=DataArrayInt64([6,0,11,8])
        c=a.indicesOfSubPart(b)
        self.assertTrue(c.isEqual(DataArrayInt([3,2,5,7])))
        #
        d=DataArrayInt64([9,10,0,6,4,11,0,8])
        self.assertRaises(InterpKernelException,d.indicesOfSubPart,b) # 0 appears twice in the d array
        f=DataArrayInt64([6,0,11,8,12])
        self.assertRaises(InterpKernelException,a.indicesOfSubPart,f) # 12 in f does not exist in a
        pass

    def testDAIFromLinkedListOfPairToList1(self):
        d=DataArrayInt64([(5,7),(7,3),(3,12),(12,17)])
        zeRes=DataArrayInt64([5,7,3,12,17])
        self.assertTrue(d.fromLinkedListOfPairToList().isEqual(zeRes))
        d.rearrange(1)
        self.assertRaises(InterpKernelException,d.fromLinkedListOfPairToList)
        d.rearrange(2)
        self.assertTrue(d.fromLinkedListOfPairToList().isEqual(zeRes))
        d2=DataArrayInt64([(5,7)])
        self.assertTrue(d2.fromLinkedListOfPairToList().isEqual(DataArrayInt64([5,7])))
        d3=DataArrayInt64([(5,7),(7,3),(4,12),(12,17)])
        self.assertRaises(InterpKernelException,d3.fromLinkedListOfPairToList) # not a linked list of pair
        d4=DataArrayInt64([(5,7),(7,3),(12,3),(12,17)])
        self.assertRaises(InterpKernelException,d4.fromLinkedListOfPairToList) # not a linked list of pair, but can be repaired !
        d4.sortEachPairToMakeALinkedList()
        self.assertTrue(d4.fromLinkedListOfPairToList().isEqual(zeRes))
        pass

    def testDAIfindIdsExt1(self):
        d=DataArrayInt64([4,6,-2,3,7,0,10])
        self.assertTrue(d.findIdsGreaterOrEqualTo(3).isEqual(DataArrayInt([0,1,3,4,6])))
        self.assertTrue(d.findIdsGreaterThan(3).isEqual(DataArrayInt([0,1,4,6])))
        self.assertTrue(d.findIdsLowerThan(3).isEqual(DataArrayInt([2,5])))
        self.assertTrue(d.findIdsLowerOrEqualTo(3).isEqual(DataArrayInt([2,3,5])))
        pass

    def testDAICheckUniformAndGuess1(self):
        d=DataArrayInt64([3,3],1,2)
        self.assertRaises(InterpKernelException,d.checkUniformAndGuess)# non single compo
        d=DataArrayInt64([])
        self.assertRaises(InterpKernelException,d.checkUniformAndGuess)# empty
        d=DataArrayInt64()
        self.assertRaises(InterpKernelException,d.checkUniformAndGuess)# non allocated
        d=DataArrayInt64([3,3,3])
        self.assertEqual(3,d.checkUniformAndGuess())
        d=DataArrayInt64([7])
        self.assertEqual(7,d.checkUniformAndGuess())
        d=DataArrayInt64([3,4,3])
        self.assertRaises(InterpKernelException,d.checkUniformAndGuess)# non uniform
        pass

    def testDAIFindIdForEach1(self):
        a1=DataArrayInt64([17,27,2,10,-4,3,12,27,16])
        b1=DataArrayInt64([3,16,-4,27,17])
        ret=a1.findIdForEach(b1)
        self.assertTrue(ret.isEqual(DataArrayInt([5,8,4,7,0])))
        self.assertTrue(a1[ret].isEqual(b1))
        b2=DataArrayInt64([3,16,22,27,17])
        self.assertRaises(InterpKernelException,a1.findIdForEach,b2) # 22 not in a1 !
        a1.rearrange(3)
        self.assertRaises(InterpKernelException,a1.findIdForEach,b1) # a1 is not single component
        pass

    def testGlobalHelpers(self):
        arr0 = vtk2med_cell_types()
        self.assertEqual(len(arr0),43)
        arr1 = med2vtk_cell_types()
        self.assertEqual(len(arr1),34)
        arr2 = AllGeometricTypes()
        self.assertEqual(len(arr2),25)
        for elt in arr2:
            MEDCouplingUMesh.GetReprOfGeometricType(elt)
            self.assertNotEqual(MEDCouplingUMesh.GetDimensionOfGeometricType(elt),-1)
        pass

    def testVoronoi2D_3(self):
        """
        Non regression test for EDF20418 : After 8.5.0 MEDCouplingUMesh.Interset2DMeshes method (called by voronoize) is sensible to cell orientation of 2 input meshes. This test check correct behavior in
        case of non standard orientation input cell.
        """
        coo = DataArrayDouble([0.018036113896685007,0.030867224641316506,0.019000000000000003,0.030833333333333407,0.018518056948342503,0.030850278987324904,0.018773068345659904,0.031180320157635305,0.018546136691319805,0.031527306981937307,0.018291125294002404,0.031197265811626906],6,2)
        m = MEDCouplingUMesh("mesh",2)
        m.setCoords(coo)
        m.allocateCells()
        m.insertNextCell(NORM_TRI3,[0,1,4])
        f=MEDCouplingFieldDouble(ON_GAUSS_PT)
        f.setMesh(m)
        f.setArray(DataArrayDouble([12613576.708019681, 18945164.734307285, 22385248.637775388, 17074219.938821714, 19361929.467164982, 19258841.562907547]))
        f.setGaussLocalizationOnType(NORM_TRI3,[0, 0, 1, 0, 0, 1],[0.0915762, 0.0915762, 0.816848, 0.0915762, 0.0915762, 0.816848, 0.445948, 0.108103, 0.445948, 0.445948, 0.108103, 0.445948],[0.0549759, 0.0549759, 0.0549759, 0.111691, 0.111691, 0.111691])
        f.setName("field")
        f_voro = f.voronoize(1e-13)
        ref_area = DataArrayDouble([4.6679303278867127, 4.2514546761810138, 4.2514546761809337, 6.6206415950989804, 6.2643538685231039, 6.6206415950989884])
        area = f_voro.buildMeasureField(True).getArray()*1e8
        self.assertTrue(ref_area.isEqual(area,1e-6))
        ref_bary = DataArrayDouble([(0.018231625096313969, 0.030950287685553721), (0.018826045778781105, 0.030916927013719033), (0.018533397739746087, 0.031364396601025746), (0.018541498169815956, 0.030944333493252929), (0.018660195622447071, 0.031132366117047686), (0.018400646702087166, 0.031159700554391174)])
        bary = f_voro.getMesh().computeCellCenterOfMass()
        self.assertTrue(ref_bary.isEqual(bary,1e-8))
        self.assertTrue(f_voro.getArray().isEqual(f.getArray(),1e-8))
        pass

    def testDAIOccurenceRankInThis(self):
        arr=DataArrayInt([5,3,2,1,4,5,2,1,0,11,5,4])
        self.assertTrue(arr.occurenceRankInThis().isEqual(DataArrayInt([0,0,0,0,0,1,1,1,0,0,2,1])))

    def testDAIFindPermutationFromFirstToSecondDuplicate(self):
        arr0 = DataArrayInt([5,3,2,1,4,5,2,1,0,11,5,4])
        arr1 = DataArrayInt([0,1,1,2,2,3,4,4,5,5,5,11])
        self.assertTrue(DataArrayInt.FindPermutationFromFirstToSecondDuplicate(arr0,arr1).isEqual(DataArrayInt([8,5,3,1,6,9,4,2,0,11,10,7])))
        self.assertTrue(DataArrayInt.FindPermutationFromFirstToSecondDuplicate(arr1,arr0).isEqual(DataArrayInt([8,3,7,2,6,1,4,11,0,5,10,9])))
        
    def testDAIIndexOfSameConsecutiveValueGroups(self):
        arr = DataArrayInt([0,1,1,2,2,3,4,4,5,5,5,11])
        self.assertTrue(arr.indexOfSameConsecutiveValueGroups().isEqual(DataArrayInt([0,1,3,5,6,8,11,12])))

    def testSkyLineGroupPacks(self):
        arr = DataArrayInt([1,4,5,0,2,4,5,6,1,3,5,6,7,2,6,7,0,1,5,8,9,0,1,2,4,6,8,9,10,1,2,3,5,7,9,10,11,2,3,6,10,11,4,5,9,12,13,4,5,6,8,10,12,13,14,5,6,7,9,11,13,14,15,6,7,10,14,15,8,9,13,8,9,10,12,14,9,10,11,13,15,10,11,14])
        arrI = DataArrayInt([0,3,8,13,16,21,29,37,42,47,55,63,68,71,76,81,84])
        sk = MEDCouplingSkyLineArray(arrI,arr)
        part = DataArrayInt([0,3,4,7,16])
        sk2 = sk.groupPacks(part)
        self.assertTrue(sk2.getValuesArray().isEqual(arr))
        self.assertTrue(sk2.getIndexArray().isEqual(DataArrayInt([0,13,16,37,84])))

    def testSkyLineUniqueNotSortedByPack(self):    
        arrI = DataArrayInt([0,3,9,15,18,24,36,48,54])
        arr = DataArrayInt([1,4,5,0,4,5,2,5,6,3,6,7,1,5,6,2,6,7,0,1,5,5,8,9,0,1,4,6,9,10,1,2,4,6,8,9,2,3,5,7,9,10,1,2,5,7,10,11,2,3,6,6,10,11])
        sk = MEDCouplingSkyLineArray(arrI,arr)
        sk2 = sk.uniqueNotSortedByPack()
        self.assertTrue(sk2.getIndexArray().isEqual(DataArrayInt([0,3,8,13,16,21,29,37,42])))
        self.assertTrue(sk2.getValuesArray().isEqual(DataArrayInt([1,4,5,0,2,4,5,6,1,3,5,6,7,2,6,7,0,1,5,8,9,0,1,2,4,6,8,9,10,1,2,3,5,7,9,10,11,2,3,6,10,11])))
    
    def testSkyLineAggregatePacks1(self):
        arr = DataArrayDouble(3) ; arr.iota()
        m = MEDCouplingCMesh() ; m.setCoords(arr,arr) ; m = m.buildUnstructured()
        a,b = m.computeEnlargedNeighborsOfNodes()
        sk = MEDCouplingSkyLineArray(b,a)
        sk1 = sk.deepCopy()
        sk1.getValuesArray()[:] *= 2
        sk2 = sk.deepCopy()
        sk2.getValuesArray()[:] *= 3
        skOut = MEDCouplingSkyLineArray.AggregatePacks([sk,sk1,sk2])
        self.assertTrue(skOut.getIndexArray().isEqual(DataArrayInt([0,9,24,33,48,72,87,96,111,120])))
        self.assertTrue(skOut.getValuesArray().isEqual(DataArrayInt([1,3,4,2,6,8,3,9,12,0,2,3,4,5,0,4,6,8,10,0,6,9,12,15,1,4,5,2,8,10,3,12,15,0,1,4,6,7,0,2,8,12,14,0,3,12,18,21,0,1,2,3,5,6,7,8,0,2,4,6,10,12,14,16,0,3,6,9,15,18,21,24,1,2,4,7,8,2,4,8,14,16,3,6,12,21,24,3,4,7,6,8,14,9,12,21,3,4,5,6,8,6,8,10,12,16,9,12,15,18,24,4,5,7,8,10,14,12,15,21])))

    def testDACopySorted1(self):
        d = DataArrayInt32([5,1,100,20])
        self.assertTrue(d.copySorted().isEqual(DataArrayInt32([1,5,20,100])))
        d = DataArrayInt64([5,1,100,20])
        self.assertTrue(d.copySorted().isEqual(DataArrayInt64([1,5,20,100])))
        d = DataArrayInt([5,1,100,20])
        self.assertTrue(d.copySorted().isEqual(DataArrayInt([1,5,20,100])))
        d = DataArrayDouble([5,1,100,20])
        self.assertTrue(d.copySorted().isEqual(DataArrayDouble([1,5,20,100]),1e-10))

    def testFieldAreStrictlyCompatible(self):
        arr=DataArrayDouble(10) ; arr.iota()
        m=MEDCouplingCMesh() ; m.setCoords(arr,arr) ; m=m.buildUnstructured()
        f=MEDCouplingFieldDouble(ON_CELLS) ; f.setMesh(m)
        f2=MEDCouplingFieldDouble(ON_CELLS) ; f2.setMesh(m)
        self.assertTrue(f.areStrictlyCompatible(f2))
        self.assertTrue(f.areStrictlyCompatibleForMulDiv(f2))
        f2.setMesh(f2.getMesh().deepCopy())
        self.assertTrue(not f.areStrictlyCompatible(f2))
        self.assertTrue(not f.areStrictlyCompatibleForMulDiv(f2))
        f3=MEDCouplingFieldDouble(ON_NODES) ; f3.setMesh(m)
        self.assertTrue(not f.areStrictlyCompatible(f3))
        self.assertTrue(not f.areStrictlyCompatibleForMulDiv(f3))

    def testBugZipConnectivityTraducer(self):
        """
        Non regression test : here cell #1 and cell #2 are nearly the same but not the same. zipConnectivityTraducer called by areCellsIncludedIn
        failed to capture that.
        """
        coo = DataArrayDouble([0,1,2,3],4,1)
        m = MEDCouplingUMesh("",1)
        m.setCoords(coo)
        m.allocateCells()
        m.insertNextCell(NORM_SEG2,[0,1])
        m.insertNextCell(NORM_SEG2,[1,2])
        m.insertNextCell(NORM_SEG2,[2,1])
        #
        a,b = m.areCellsIncludedIn(m,0)
        self.assertTrue(a)
        self.assertTrue(b.isIota(3))
        #
        self.assertTrue(m.deepCopy().zipConnectivityTraducer(0).isIota(3))
        self.assertTrue(m.deepCopy().zipConnectivityTraducer(1).isIota(3))
        self.assertTrue(m.deepCopy().zipConnectivityTraducer(2).isEqual(DataArrayInt([0,1,1])))

    def testBugAreCellsIncludedIn1(self):
        """
        Non regression test: a.areCellsIncludedIn(b) was buggy when some cells in b were duplicated into a following specified policy.
        """
        coo = DataArrayDouble([0,1,2,3,4],5,1)
        m = MEDCouplingUMesh("",1)
        m.setCoords(coo)
        m.allocateCells()
        # m contains several duplicated cells - some of those duplicated cells will be in m1
        for i in range(3):
            m.insertNextCell(NORM_SEG2,[0,1])
        for i in range(4):
            m.insertNextCell(NORM_SEG2,[1,2])
        for i in range(2):
            m.insertNextCell(NORM_SEG2,[2,3])
        for i in range(2):
            m.insertNextCell(NORM_SEG2,[3,4])
        #
        bexp = DataArrayInt([0,1,2, 3,4,5,6, 9,10])
        m1 = m[bexp]
        #
        a,b = m.areCellsIncludedIn(m1,0)
        self.assertTrue(a)
        self.assertTrue(b.isEqual(DataArrayInt([2,2,2, 6,6,6,6, 10,10])))
        #
        bexp2 = DataArrayInt([0,1,2, 3,4,0, 6, 9,10])
        m2 = m[bexp2]
        a,b = m.areCellsIncludedIn(m2,0)
        self.assertTrue(a)
        self.assertTrue(b.isEqual(DataArrayInt([2,2,2,6,6,2,6,10,10])))

    def testSkyLineArrayThreshold(self):
        x = DataArrayInt([0, 1, 2, 11, 12, 13, 3, 4, 5, 6, 14, 15, 16, 17, 9, 10, 18, 19])
        xi = DataArrayInt([0, 6, 14, 18])
        sk = MEDCouplingSkyLineArray(xi,x)
        lsk,rsk = sk.thresholdPerPack(11)
        self.assertTrue(lsk.getValuesArray().isEqual(DataArrayInt([0, 1, 2, 3, 4, 5, 6, 9, 10])))
        self.assertTrue(lsk.getIndexArray().isEqual(DataArrayInt([0, 3, 7, 9])))
        self.assertTrue(rsk.getValuesArray().isEqual(DataArrayInt([11, 12, 13, 14, 15, 16, 17, 18, 19])))
        self.assertTrue(rsk.getIndexArray().isEqual(DataArrayInt([0, 3, 7, 9])))
    
    def testPenta18GaussNE(self):
        conn = [1,0,2,4,3,5,6,7,8,9,13,14,11,10,15,12,17,16]
        coo = DataArrayDouble([(27.237499999999997, 9.8, 0.0), (26.974999999999994, 9.8, 0.0), (27.111517409545634, 9.532083869948877, 0.0), (27.237499999999997, 9.8, 0.5000000000000001), (26.974999999999994, 9.8, 0.5000000000000002), (27.111517409545634, 9.532083869948877, 0.5), (27.106249999999996, 9.8, 0.0), (27.17450870477282, 9.666041934974439, 0.0), (27.04325870477281, 9.666041934974439, 0.0), (27.106249999999996, 9.8, 0.5000000000000001), (27.237499999999997, 9.8, 0.25), (26.974999999999994, 9.8, 0.2500000000000001), (27.106249999999996, 9.8, 0.2500000000000001), (27.174508704772816, 9.666041934974439, 0.5), (27.043258704772814, 9.666041934974439, 0.5000000000000001), (27.111517409545634, 9.532083869948877, 0.25), (27.043258704772818, 9.666041934974436, 0.25000000000000006), (27.174508704772816, 9.666041934974436, 0.25)])
        m = MEDCouplingUMesh("mesh",3)
        m.setCoords(coo)
        m.allocateCells()
        m.insertNextCell(NORM_PENTA18,conn)
        f = MEDCouplingFieldDouble(ON_GAUSS_NE)
        f.setMesh(m)
        f.setArray(DataArrayDouble(18*[0.]))
        self.assertTrue(f.getLocalizationOfDiscr().isEqual(coo[conn],1e-10))

    def testDADEigenValuesPb(self):
        """EDF22126 : eigen values with Identity matrix returned nan. Now it returns correct eigen values 1.0 """
        valuesExp = DataArrayDouble([(1.,1.,1.),(2.,-1.,0.),(2.,0.,1.),(3.,0.,0.)])
        d = DataArrayDouble(4, 6)
        for i,(v0, v1, v2, v3, v4, v5,) in enumerate([
                (1, 1, 1, 0, 0, 0),
                (1, 0, 0, 1, 0, 1),
                (1, 1, 1, 0, 1, 0),
                (1, 1, 1, 1, 1, 1)]):
            d[i] = [v0, v1, v2, v3, v4, v5]
        self.assertTrue(d.eigenValues().isEqual(valuesExp,1e-12))
        pass

    def testBugOnReprOf1SGTUMesh(self):
        """ Non reg bug on repr of empty MEDCoupling1SGTUMesh instance """
        m = MEDCoupling1SGTUMesh()
        m.simpleRepr()
        str(m)
        m.advancedRepr()
        repr(m)
        m = MEDCoupling1DGTUMesh()
        m.simpleRepr()
        str(m)
        m.advancedRepr()
        repr(m)

    def testCheckGeomConsistency0(self):
        """Test of MEDCouplingUMesh.checkGeomConsistency"""
        m = MEDCouplingUMesh("",2)
        m.setCoords(DataArrayDouble([(0,0),(1,0),(2,0),(0,1),(1,1),(2,1)]))
        m.allocateCells()
        m.insertNextCell(NORM_TRI6,[0,1,2,3,4,5])
        m.insertNextCell(NORM_TRI6,[0,1,3,3,4,5])
        m.checkConsistency()
        self.assertRaises(InterpKernelException,m.checkGeomConsistency) # cell1 is incorrect because node 3 is repeated twice
        m.getNodalConnectivity()[10]=2 # replace 3 by 2 for cell#1 to fix the problem
        m.checkConsistency()
        m.checkGeomConsistency() # now m is OK

    pass

if __name__ == '__main__':
    unittest.main()
