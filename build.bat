@echo on
:: prequisites: curl, cmake, ninja, 7z


echo PATH=%PATH%
rem  set "PATH=%PATH%;C:\ProgramData\Chocolatey\bin;C:\ProgramData\chocolatey\lib\ninja\tools"

:: shorten PATH
set "PATH=C:\Windows\system32;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\Git\bin;C:\Program Files\Git\usr\bin;C:\ProgramData\Chocolatey\bin;C:\ProgramData\chocolatey\lib\ninja\tools;C:\Program Files (x86)\CMake\bin;C:\Tools\curl\bin;C:\Program Files\7-Zip"

echo "ninja..."
choco install ninja
where ninja
where curl
where 7z
where cmake
where sed
ninja --version
mkdir C:\work

:: from windows binary archive
curl -LO https://files.salome-platform.org/Salome/Salome9.10.0/SALOME-9.10.0-e3540918ac897f3118c2a971e9344502.zip
7z x SALOME-9.10.0-e3540918ac897f3118c2a971e9344502.zip -oC:\work > nul
:: cmake config files are not relocatable
rem  xcopy SalomeKERNELConfig.cmake C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files /y /s
rem  xcopy LibBatchConfig.cmake C:\work\SALOME-9.10.0\W64\EXT\cmake\ /y /s
rem  xcopy SalomeGUIConfig.cmake C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files /y /s
rem  xcopy MEDCouplingConfig.cmake C:\work\SALOME-9.10.0\W64\MEDCOUPLING\cmake_files /y /s
rem  xcopy SalomeGEOMConfig.cmake C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files /y /s
rem  xcopy SalomeSMESHConfig.cmake C:\work\SALOME-9.10.0\W64\SMESH\adm_local\cmake_files /y /s

sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files\SalomeKERNELConfig.cmake
type C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files\SalomeKERNELConfig.cmake

sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\EXT\cmake\LibBatchConfig.cmake
type  C:\work\SALOME-9.10.0\W64\EXT\cmake\LibBatchConfig.cmake

sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files\SalomeGUIConfig.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\MEDCOUPLING\cmake_files\MEDCouplingConfig.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files\SalomeGEOMConfig.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\SMESH\adm_local\cmake_files\SalomeSMESHConfig.cmake

sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\EXT\cmake\LibBatchTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\YACS\adm\cmake\SalomeYACSTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files\SalomeGEOMTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files\SalomeKERNELTargets-release.cmake

sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\CAS\cmake\OpenCASCADEModelingDataTargets.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\CAS\cmake\OpenCASCADEVisualizationTargets.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\CAS\cmake\OpenCASCADEFoundationClassesTargets.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\CAS\cmake\OpenCASCADEModelingAlgorithmsTargets.cmake

:: 'E:/S/SALOME-9.10.0/W64/omniORB/lib/x86_win32/omniORB4_rt.lib', needed by 'src/HOMARD_I/HOMARDEngine.dll', missing
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\HEXABLOCKPLUGIN\adm_local\cmake_files\SalomeHEXABLOCKPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\CALCULATOR\adm_local\cmake_files\SalomeCALCULATORTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\FIELDS\adm_local\cmake_files\SalomeFIELDSTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\NETGENPLUGIN\adm_local\cmake_files\SalomeNETGENPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GMSHPLUGIN\adm_local\cmake_files\SalomeGMSHPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\COMPONENT\adm_local\cmake_files\SalomeCOMPONENTTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\PYCALCULATOR\adm_local\cmake_files\SalomePYCALCULATORTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\BLSURFPLUGIN\adm_local\cmake_files\SalomeBLSURFPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\EFICAS\adm_local\cmake_files\SalomeEFICASTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\YACS\adm\cmake\SalomeYACSTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\JOBMANAGER\adm_local\cmake_files\SalomeJOBMANAGERTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\SHAPERSTUDY\adm_local\cmake_files\SalomeSHAPERSTUDYTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\HexoticPLUGIN\adm_local\cmake_files\SalomeHexoticPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files\SalomeGEOMTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GHS3DPLUGIN\adm_local\cmake_files\SalomeGHS3DPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files\SalomeKERNELTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\HELLO\adm_local\cmake_files\SalomeHELLOTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\PYHELLO\adm_local\cmake_files\SalomePYHELLOTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\SMESH\adm_local\cmake_files\SalomeSMESHTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\HYBRIDPLUGIN\adm_local\cmake_files\SalomeHYBRIDPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files\SalomeGUITargets-release.cmake

:: 'E:/S/SALOME-9.10.0/W64/Python/python36.lib', needed by 'src/HOMARDGUI/HOMARD.dll', missing
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\FIELDS\adm_local\cmake_files\SalomeFIELDSTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\BLSURFPLUGIN\adm_local\cmake_files\SalomeBLSURFPLUGINTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\YACS\adm\cmake\SalomeYACSTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files\SalomeGEOMTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files\SalomeKERNELTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\HEXABLOCK\adm_local\cmake_files\SalomeHEXABLOCKTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files\SalomeGUITargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files\SalomeCURVEPLOTTargets-release.cmake
sed -i "s|E:/S/SALOME|C:/work/SALOME|g" C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files\SalomeGUITargets.cmake

:: missing sip headers
copy /b NUL C:\work\SALOME-9.10.0\W64\EXT\include\sip.h

:: fatal error LNK1104: cannot open file 'libboost_filesystem-vc141-mt-x64-1_67.lib'
dir /p C:\work\SALOME-9.10.0\W64\EXT\lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_filesystem-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_filesystem-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_thread-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_thread-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_regex-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_regex-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_date_time-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_date_time-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_chrono-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_chrono-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_serialization-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_serialization-vc141-mt-x64-1_67.lib
copy C:\work\SALOME-9.10.0\W64\EXT\lib\boost_system-vc141-mt-x64-1_67.lib C:\work\SALOME-9.10.0\W64\EXT\lib\libboost_system-vc141-mt-x64-1_67.lib

:: rebuild med fortran lib

cd C:\work
curl -LO https://files.salome-platform.org/Salome/other/med-4.1.1.tar.gz
7z x med-4.1.1.tar.gz > nul
7z x med-4.1.1.tar > nul
rem  type med-4.1.1_SRC\src\fi\CMakeLists.txt
rem  xcopy /y /s /f %APPVEYOR_BUILD_FOLDER%\medficmakelists.txt med-4.1.1_SRC\src\fi\CMakeLists.txt
rem  xcopy /y /s /f %APPVEYOR_BUILD_FOLDER%\CMakeLists.txt.medsrc med-4.1.1_SRC\src\CMakeLists.txt
rem  type med-4.1.1_SRC\src\CMakeLists.txt
set "PATH=%PATH%;C:\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin"
cmake -S med-4.1.1_SRC -B build_med -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.10.0/W64/medf -DMEDFILE_BUILD_TESTS=OFF -DMEDFILE_INSTALL_DOC=OFF -DHDF5_ROOT_DIR=C:/work/SALOME-9.10.0/W64/EXT -DCMAKE_Fortran_FLAGS="-ffixed-line-length-0 -fdefault-double-8 -fdefault-real-8 -fdefault-integer-8 -fimplicit-none -O2" -DMED_MEDINT_TYPE="long long" -DZCMAKE_IMPORT_LIBRARY_PREFIX="" -DZCMAKE_IMPORT_LIBRARY_SUFFIX=".lib"
cmake --build build_med --config Release --target install





echo "swiglib..."
swig -swiglib
swig -version


git clone -b win32 https://github.com/jschueller/homard.git
rem  echo add_definitions (-DBOOST_ALL_DYN_LINK) >> homard\CMakeLists.txt

echo #define FortranCInterface_GLOBAL(name, NAME) name##_ >> homard/src/tool/FC.h
type homard/src/tool/FC.h

rem  set "PATH=%PATH%;C:\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin"

cmake -S homard/src/tool -B homard_fortran_build -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.10.0/W64/homard_fortran -DMEDFILE_LIBRARIES=C:/work/SALOME-9.10.0/W64/medf/lib/libmedfwrap.dll.a
cmake --build homard_fortran_build --config Release --target install

:: now build without homard fortran executable
rem  xcopy /y /s /f %APPVEYOR_BUILD_FOLDER%\CMakeLists.txt.homardsrc homard\src
sed -i "s|tool||g" homard\src\CMakeLists.txt

call "C:\work\SALOME-9.10.0\env_launch.bat"
cmake --version
echo PATH=%PATH%




call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
echo PATH=%PATH%

echo "import omniorb..."
python3 -c "import omniORB; print(888)"
echo "import omniidl_be..."
python3 -c "import omniidl_be; print(888)"


cmake -S homard -B build_homard -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.10.0/W64/homard ^
  -DSALOME_BUILD_DOC=OFF
cmake --build build_homard --config Release --target install

dir /p build_homard\src\HOMARD
dir /p build_homard\src\HOMARD_I
dir /p build_homard\src\HOMARD_SWIG
dir /p build_homard\idl
rem  findstr "generated by omniidl" build_homard\*.*


:: see homard/src/tests/Test/CTestTestfileInstall.cmake
python %KERNEL_ROOT_DIR%\bin\salome\appliskel\salome_test_driver.py 500 homard\src\tests\Test\test_1.py
