@echo on
:: prequisites: curl, cmake, ninja, 7z


echo PATH=%PATH%
rem  set "PATH=%PATH%;C:\ProgramData\Chocolatey\bin;C:\ProgramData\chocolatey\lib\ninja\tools"

:: shorten PATH
set "PATH=C:\Windows\system32;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Program Files (x86)\Windows Kits\10\Windows Performance Toolkit\;C:\Program Files\Git\bin;C:\ProgramData\Chocolatey\bin;C:\ProgramData\chocolatey\lib\ninja\tools;C:\Program Files (x86)\CMake\bin;C:\Tools\curl\bin;C:\Program Files\7-Zip"

echo "ninja..."
choco install ninja
where ninja
where curl
where 7z
where cmake
ninja --version


mkdir C:\work
cd C:\work



:: rebuild med fortran lib
curl -LO https://files.salome-platform.org/Salome/other/med-4.1.1.tar.gz
7z x med-4.1.1.tar.gz > nul
7z x med-4.1.1.tar > nul
rem  type med-4.1.1_SRC\src\fi\CMakeLists.txt
rem  xcopy /y /s /f %APPVEYOR_BUILD_FOLDER%\medficmakelists.txt med-4.1.1_SRC\src\fi\CMakeLists.txt
rem  xcopy /y /s /f %APPVEYOR_BUILD_FOLDER%\CMakeLists.txt.medsrc med-4.1.1_SRC\src\CMakeLists.txt
rem  type med-4.1.1_SRC\src\CMakeLists.txt
set "PATH=%PATH%;C:\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin"
cmake -S med-4.1.1_SRC -B build_med -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/medf
cmake --build build_med --config Release --target install


:: from windows binary archive
cd C:\work
curl -LO https://files.salome-platform.org/Salome/Salome9.10.0/SALOME-9.10.0-e3540918ac897f3118c2a971e9344502.zip
7z x SALOME-9.10.0-e3540918ac897f3118c2a971e9344502.zip > nul
:: cmake config files are not relocatable
xcopy SalomeKERNELConfig.cmake C:\work\SALOME-9.10.0\W64\KERNEL\salome_adm\cmake_files /y /s
xcopy LibBatchConfig.cmake C:\work\SALOME-9.10.0\W64\EXT\cmake\ /y /s
xcopy SalomeGUIConfig.cmake C:\work\SALOME-9.10.0\W64\GUI\adm_local\cmake_files /y /s
xcopy MEDCouplingConfig.cmake C:\work\SALOME-9.10.0\W64\MEDCOUPLING\cmake_files /y /s
xcopy SalomeGEOMConfig.cmake C:\work\SALOME-9.10.0\W64\GEOM\adm_local\cmake_files /y /s
xcopy SalomeSMESHConfig.cmake C:\work\SALOME-9.10.0\W64\SMESH\adm_local\cmake_files /y /s
:: missing sip headers
copy /b NUL C:\work\SALOME-9.10.0\W64\EXT\include\sip.h

call "C:\work\SALOME-9.10.0\env_launch.bat"
echo PATH=%PATH%

echo "swiglib..."
swig -swiglib
swig -version
rem  dir /p C:\work\SALOME-9.10.0\W64\swig\bin
rem  C:\work\SALOME-9.10.0\W64\swig\bin\swig.exe -swiglib
rem  C:\work\SALOME-9.10.0\W64\swig\bin\swig.exe -version
rem  xcopy C:/work/SALOME-9.10.0/W64/swig/bin/swig.exe C:/work/SALOME-9.10.0/W64/swig/ /y /s


git clone https://github.com/jschueller/homard.git

echo #define FortranCInterface_GLOBAL(name, NAME) name##_ >> homard/src/tool/FC.h
type homard/src/tool/FC.h

set "PATH=%PATH%;C:\mingw-w64\x86_64-7.2.0-posix-seh-rt_v5-rev1\mingw64\bin"



rem  git clone -b fortran https://github.com/jschueller/swig-cmake-example.git
rem  cmake -S swig-cmake-example -B build2 -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release
rem  type build2\FC.h


cmake -S homard/src/tool -B homard_fortran_build -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/homard_fortran -DMEDFILE_LIBRARIES=C:/work/SALOME-9.7.0/W64/medf/lib/medfwrap.lib
cmake --build homard_fortran_build --config Release --target install
exit /b 0

call "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvarsall.bat" amd64
echo PATH=%PATH%

rem  -G "Visual Studio 15 2017" -A amd64
cmake -S homard -B homard_build -G "Ninja" -LAH -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/homard
rem    -DCONFIGURATION_ROOT_DIR=C:/work/SALOME-9.10.0/SOURCES/CONFIGURATION ^
rem    -DKERNEL_ROOT_DIR=C:/work/SALOME-9.10.0/W64/KERNEL ^
rem    -DGUI_ROOT_DIR=C:/work/SALOME-9.10.0/W64/GUI ^
rem    -DGEOM_ROOT_DIR=C:/work/SALOME-9.10.0/W64/GEOM ^
rem    -DSMESH_ROOT_DIR=C:/work/SALOME-9.10.0/W64/SMESH ^
rem    -Dospray_DIR=C:/work/SALOME-9.10.0/W64/EXT/lib/cmake/ospray-2.4.0 ^
rem    -Dembree_DIR=C:/work/SALOME-9.10.0/W64/EXT/lib/cmake/embree-3.12.2 ^
rem    -Dopenvkl_DIR=C:/work/SALOME-9.10.0/W64/EXT/lib/cmake/openvkl-0.11.0 ^
rem    -Drkcommon_DIR=C:/work/SALOME-9.10.0/W64/EXT/lib/cmake/rkcommon-1.5.1 ^
rem    -DTBB_DIR=C:/work/SALOME-9.10.0/W64/EXT/lib/cmake/tbb/ -DTBB_ROOT=C:/work/SALOME-9.10.0/W64/EXT/ ^
rem    -DCGNS_INCLUDE_DIR=C:/work/SALOME-9.10.0/W64/EXT/include -DCGNS_LIBRARY=C:/work/SALOME-9.10.0/W64/EXT/lib/cgns.lib ^
rem    -DPYTHON_EXECUTABLE=C:/work/SALOME-9.10.0/W64/Python/python3.exe ^
rem    -DPython3_EXECUTABLE=C:/work/SALOME-9.10.0/W64/Python/python3.exe ^
rem    -DPYTHON_LIBRARY=C:/work/SALOME-9.10.0/W64/Python/python3.lib ^ -DPYTHON_INCLUDE_DIR=C:/work/SALOME-9.10.0/W64/Python/include ^
rem    -DPYTHONINTERP_ROOT_DIR=C:/work/SALOME-9.10.0/W64/Python -DPYTHONLIBS_ROOT_DIR=C:/work/SALOME-9.10.0/W64/Python ^
rem    -DPYTHON_ROOT_DIR=C:/work/SALOME-9.10.0/W64/Python ^
rem    -DMEDCOUPLING_ROOT_DIR=C:/work/SALOME-9.10.0/W64/MEDCOUPLING ^
rem    -DFREETYPE_INCLUDE_DIR_freetype2=C:/work/SALOME-9.10.0/W64/EXT/include/freetype2 ^
rem    -DFREETYPE_INCLUDE_DIR_ft2build=C:/work/SALOME-9.10.0/W64/EXT/include/freetype2 ^
rem    -DFREETYPE_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/freetype.lib ^
rem    -DBOOST_ROOT_DIR=C:/work/SALOME-9.10.0/W64/EXT ^
rem    -DBoost_LIBRARY_DIR_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib -DBOOST_LIBRARYDIR=C:/work/SALOME-9.10.0/W64/EXT/lib ^
rem    -DBoost_ATOMIC_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_atomic-vc141-mt-x64-1_67.lib ^
rem    -DBoost_CHRONO_LIBRARY_RELEASE==C:/work/SALOME-9.10.0/W64/EXT/lib/boost_chrono-vc141-mt-x64-1_67.lib ^
rem    -DBoost_DATE_TIME_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_date_time-vc141-mt-x64-1_67.lib ^
rem    -DBoost_FILESYSTEM_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_filesystem-vc141-mt-x64-1_67.lib ^
rem    -DBoost_REGEX_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_regex-vc141-mt-x64-1_67.lib ^
rem    -DBoost_SERIALIZATION_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_serialization-vc141-mt-x64-1_67.lib ^
rem    -DBoost_SYSTEM_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_system-vc141-mt-x64-1_67.lib ^
rem    -DBoost_THREAD_LIBRARY_RELEASE=C:/work/SALOME-9.10.0/W64/EXT/lib/boost_thread-vc141-mt-x64-1_67.lib ^
rem    -DOMNIORB_ROOT_DIR=C:/work/SALOME-9.10.0/W64/omniORB ^
rem    -DOMNIORB_LIBRARY_COS4=C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32/COS4_rt.lib ^
rem    -DOMNIORB_LIBRARY_COSDynamic4=C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32/COSDynamic4_rt.lib ^
rem    -DOMNIORB_LIBRARY_omniDynamic4=C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32/omniDynamic4_rt.lib ^
rem    -DOMNIORB_LIBRARY_omniORB4=C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32/omniORB4_rt.lib ^
rem    -DOMNIORB_LIBRARY_omnithread=C:/work/SALOME-9.10.0/W64/omniORB/lib/x86_win32/omnithread_rt.lib ^
rem    -DSIP_ROOT_DIR=C:/work/SALOME-9.10.0/W64/sip ^
rem    -DSIP_INCLUDE_DIR=C:/work/SALOME-9.10.0/W64/EXT/include ^
rem    -DOpenCV_DIR=C:/work/SALOME-9.10.0/W64/EXT ^
rem    -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.10.0/W64/EXT/include -DZLIB_LIBRARY=C:/work/SALOME-9.10.0/W64/EXT/lib/zlib.lib ^
rem    -DLIBXML2_INCLUDE_DIR=C:/work/SALOME-9.10.0/W64/EXT/include -DLIBXML2_LIBRARY=C:/work/SALOME-9.10.0/W64/EXT/lib/libxml2.lib

rem    -DSWIG_EXECUTABLE=C:/work/SALOME-9.10.0/W64/swig/bin/swig.exe -DSWIG_ROOT_DIR=C:/work/SALOME-9.10.0/W64/swig ^
rem    -DZSWIG_DIR=C:/work/SALOME-9.10.0/W64/swig/Lib -DSWIG_VERSION=3.0.12 -DSALOME_CMAKE_DEBUG=ON ^
exit /b 0
cmake --build homard_build --config Release --target install
exit /b 0

:: zlib
git clone --depth 1 https://github.com/madler/zlib.git
cmake -LAH -S zlib -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/zlib -DCMAKE_BUILD_TYPE=Release && cmake --build . --config Release --target install

:: protobuf
curl -LO https://github.com/protocolbuffers/protobuf/archive/refs/tags/v3.19.4.zip
7z x v3.19.4.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/protobuf-3.19.4/cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/protobuf -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DCMAKE_MSVC_RUNTIME_LIBRARY=MultiThreadedDLL -Dprotobuf_MSVC_STATIC_RUNTIME=OFF -Dprotobuf_BUILD_SHARED_LIBS=ON -Dprotobuf_BUILD_TESTS=OFF -DCMAKE_C_FLAGS_RELEASE="/MD /O2 /Ob2 /DNDEBUG" -DCMAKE_CXX_FLAGS_RELEASE="/MD /O2 /Ob2 /DNDEBUG" && cmake --build . --config Release --target install
set "PATH=C:/work/SALOME-9.7.0/W64/protobuf/bin;C:/work/SALOME-9.7.0/W64/zlib/bin;%PATH%"
protoc --version

:: openssl
git clone https://github.com/janbar/openssl-cmake.git
del CMakeCache.txt
cmake -LAH -S openssl-cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/openssl -DCMAKE_BUILD_TYPE=Release -DMSVC_DYNAMIC_RUNTIME=ON && cmake --build . --config Release --target install

:: expat
curl -LO https://github.com/libexpat/libexpat/archive/refs/tags/R_2_4_3.zip
7z x R_2_4_3.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/libexpat-R_2_4_3/expat -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/expat -DCMAKE_BUILD_TYPE=Release -DEXPAT_BUILD_TESTS=OFF && cmake --build . --config Release --target install

:: exiv2
curl -LO https://github.com/Exiv2/exiv2/archive/refs/tags/v0.27.5.zip
7z x v0.27.5.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/exiv2-0.27.5 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/exiv2 -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DEXPAT_LIBRARY=C:/work/SALOME-9.7.0/W64/expat/lib/libexpat.lib -DEXPAT_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/expat/include && cmake --build . --config Release --target install

:: qca
git clone https://github.com/KDE/qca.git && cd qca && git checkout 24e702e6 && git cherry-pick -n f9442206 d6aef82d cfea7339 && cd ..
del CMakeCache.txt
cmake -LAH -S qca -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/qca -DCMAKE_BUILD_TYPE=Release -DQt5_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5 -DOPENSSL_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/openssl/include -DOPENSSL_SSL_LIBRARY=C:/work/SALOME-9.7.0/W64/openssl/lib/libssl-1_1-x64.lib -DOPENSSL_CRYPTO_LIBRARY=C:/work/SALOME-9.7.0/W64/openssl/lib/libcrypto-1_1-x64.lib -DLIB_EAY_DEBUG=C:/work/SALOME-9.7.0/W64/openssl/lib/libcrypto-1_1-x64.lib -DLIB_EAY_RELEASE=C:/work/SALOME-9.7.0/W64/openssl/lib/libcrypto-1_1-x64.lib -DSSL_EAY_DEBUG=C:/work/SALOME-9.7.0/W64/openssl/lib/libssl-1_1-x64.lib -DSSL_EAY_RELEASE=C:/work/SALOME-9.7.0/W64/openssl/lib/libssl-1_1-x64.lib -DBUILD_TESTS=OFF && cmake --build . --config Release --target install

:: qtkeychain
curl -LO https://github.com/frankosterfeld/qtkeychain/archive/refs/tags/v0.12.0.zip
7z x v0.12.0.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/qtkeychain-0.12.0 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/qtkeychain -DCMAKE_BUILD_TYPE=Release -DQt5_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5 && cmake --build . --config Release --target install

:: bzip2
git clone --depth 1 https://gitlab.com/federicomenaquintero/bzip2.git
del CMakeCache.txt
cmake -LAH -S bzip2 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/bzip2 -DCMAKE_BUILD_TYPE=Release && cmake --build . --config Release --target install

:: libzip
curl -LO https://github.com/nih-at/libzip/archive/refs/tags/v1.8.0.zip
7z x v1.8.0.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/libzip-1.8.0 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/libzip -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DBZIP2_LIBRARIES=C:/work/SALOME-9.7.0/W64/bzip2/lib/bz2.lib -DBZIP2_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/bzip2/include -DENABLE_BZIP2=OFF && cmake --build . --config Release --target install

:: minizip
curl -LO https://github.com/zlib-ng/minizip-ng/archive/refs/tags/3.0.4.zip
7z x 3.0.4.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/minizip-ng-3.0.4 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/minizip -DCMAKE_BUILD_TYPE=Release -DBZIP2_LIBRARY=C:/work/SALOME-9.7.0/W64/bzip2/lib/bz2.lib -DBZIP2_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/bzip2/include -DMZ_LZMA=OFF -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include && cmake --build . --config Release --target install

:: libxml2
git clone https://github.com/robotology-dependencies/libxml2-cmake-buildsystem.git
del CMakeCache.txt
cmake -LAH -S libxml2-cmake-buildsystem -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/libxml2 -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DLIBXML2_WITH_LZMA=OFF -DWITH_LZMA=OFF -DLIBXML2_WITH_ICONV=OFF -DWITH_ICONV=OFF && cmake --build . --config Release --target install

:: libjpeg
curl -LO https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/2.1.2.zip
7z x 2.1.2.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/libjpeg-turbo-2.1.2 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/jpeg -DCMAKE_BUILD_TYPE=Release && cmake --build . --config Release --target install

:: libgeos
curl -LO https://github.com/libgeos/geos/archive/refs/tags/3.9.2.zip
7z x 3.9.2.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/geos-3.9.2 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/geos -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF -DBUILD_BENCHMARKS=OFF && cmake --build . --config Release --target install

:: sqlite
git clone --depth 1 https://github.com/jschueller/sqlite-amalgamation.git
del CMakeCache.txt
cmake -LAH -S sqlite-amalgamation -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/sqlite -DCMAKE_BUILD_TYPE=Release -DSQLITE_ENABLE_RTREE=ON -DSQLITE_ENABLE_COLUMN_METADATA=ON -DSQLITE_OMIT_DECLTYPE=OFF -DBUILD_SHELL=ON -DBUILD_SHELL_STATIC=OFF && cmake --build . --config Release --target install

:: proj
curl -LO https://github.com/OSGeo/PROJ/archive/refs/tags/8.0.1.zip
7z x 8.0.1.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/proj-8.0.1 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/proj -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DENABLE_TIFF=OFF -DENABLE_CURL=OFF -DBUILD_PROJSYNC=OFF -DBUILD_TESTING=OFF -DSQLITE3_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/sqlite/include -DSQLITE3_LIBRARY=C:/work/SALOME-9.7.0/W64/sqlite/lib/sqlite3.lib -DEXE_SQLITE3=C:/work/SALOME-9.7.0/W64/sqlite/bin/sqlite3 && cmake --build . --config Release --target install

:: gdal
git clone --depth 1000 https://github.com/OSGeo/gdal.git
pushd gdal && git checkout 2cb83163 && popd
del CMakeCache.txt
cmake -LAH -S gdal -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/gdal -DCMAKE_BUILD_TYPE=Release -DPROJ_LIBRARY=C:/work/SALOME-9.7.0/W64/proj/lib/proj.lib -DPROJ_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/proj/include -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DGDAL_USE_MYSQL=OFF -DGDAL_USE_SQLITE3=OFF -DGDAL_ENABLE_PLUGINS=OFF -DJPEG_LIBRARY=C:/work/SALOME-9.7.0/W64/jpeg/lib/jpeg.lib -DJPEG_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/jpeg/include -DRENAME_INTERNAL_LIBJPEG_SYMBOLS=OFF -DBUILD_APPS=OFF -DBUILD_CSHARP_BINDINGS=OFF -DBUILD_DOCS=OFF -DBUILD_JAVA_BINDINGS=OFF -DBUILD_PYTHON_BINDINGS=OFF -DBUILD_TESTING=OFF && cmake --build . --config Release --target install

:: spatialite
git clone --depth 1 https://github.com/jschueller/libspatialite.git
del CMakeCache.txt
cmake -LAH -S libspatialite -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/spatialite -DCMAKE_BUILD_TYPE=Release -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DPROJ_LIBRARY=C:/work/SALOME-9.7.0/W64/proj/lib/proj.lib -DPROJ_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/proj/include -DGEOS_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/geos/include -DGEOS_LIBRARY=C:/work/SALOME-9.7.0/W64/geos/lib/geos_c.lib -DMINIZIP_LIBRARY=C:/work/SALOME-9.7.0/W64/minizip/lib/libminizip.lib -DMINIZIP_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/minizip/include -DLIBXML2_LIBRARY=C:/work/SALOME-9.7.0/W64/libxml2/lib/xml2.lib -DLIBXML2_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/libxml2/include/libxml2 -DSQLite3_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/sqlite/include -DSQLite3_LIBRARY=C:/work/SALOME-9.7.0/W64/sqlite/lib/sqlite3.lib && cmake --build . --config Release --target install

:: spatialindex
curl -LO https://github.com/libspatialindex/libspatialindex/archive/refs/tags/1.9.3.zip
7z x 1.9.3.zip -oC:\work > nul
del CMakeCache.txt
cmake -LAH -S C:/work/libspatialindex-1.9.3 -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/spatialindex -DCMAKE_BUILD_TYPE=Release && cmake --build . --config Release --target install

:: qscintilla
git clone --depth 1 https://github.com/nextgis-borsch/lib_qscintilla.git
del CMakeCache.txt
cmake -LAH -S lib_qscintilla -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/qscintilla -DCMAKE_BUILD_TYPE=Release -DQt5_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5 -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DZLIB_DLL=C:/work/SALOME-9.7.0/W64/zlib/bin/zlib.dll -DBUILD_SHARED_LIBS=ON && cmake --build . --config Release --target install

:: bison/flex
curl -LO https://downloads.sourceforge.net/winflexbison/files/win_flex_bison3-latest.zip
7z x win_flex_bison3-latest.zip -oC:\work > nul

:: qt
curl -LO https://download.qt.io/archive/qt/5.12/5.12.10/submodules/qtbase-everywhere-src-5.12.10.zip
7z x qtbase-everywhere-src-5.12.10.zip -oC:\work > nul
call qt-5.12.10.bat
nmake
nmake install

:: qgis
curl -LO https://github.com/qgis/QGIS/archive/refs/tags/final-3_16_16.zip
7z x final-3_16_16.zip -oC:\work > nul
dir /p C:\work
del CMakeCache.txt
echo include_directories (SYSTEM ${SQLITE3_INCLUDE_DIR}) >> C:\work\QGIS-final-3_16_16\src\providers\wms\CMakeLists.txt
echo target_link_libraries (wmsprovider ${SQLITE3_LIBRARY}) >> C:\work\QGIS-final-3_16_16\src\providers\wms\CMakeLists.txt
echo target_link_libraries (wmsprovider_a ${SQLITE3_LIBRARY}) >> C:\work\QGIS-final-3_16_16\src\providers\wms\CMakeLists.txt
cmake -LAH -S "C:/work/QGIS-final-3_16_16" -G "Ninja" -DCMAKE_INSTALL_PREFIX=C:/work/SALOME-9.7.0/W64/qgis -DCMAKE_BUILD_TYPE=Release -DFLEX_EXECUTABLE=C:/work/win_flex.exe -DBISON_EXECUTABLE=C:/work/win_bison.exe -DGEOS_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/geos/include -DGEOS_LIBRARY=C:/work/SALOME-9.7.0/W64/geos/lib/geos_c.lib -DGDAL_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/gdal/include -DGDAL_LIBRARY=C:/work/SALOME-9.7.0/W64/gdal/lib/gdal.lib -DLIBZIP_LIBRARY=C:/work/SALOME-9.7.0/W64/libzip/lib/zip.lib -DLIBZIP_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/libzip/include -DLIBZIP_CONF_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/libzip/include -DProtobuf_LIBRARY=C:/work/SALOME-9.7.0/W64/protobuf/lib/libprotobuf.lib -DProtobuf_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/protobuf/include -DProtobuf_LITE_LIBRARY=C:/work/SALOME-9.7.0/W64/protobuf/lib/libprotobuf-lite.lib -DProtobuf_PROTOC_EXECUTABLE=C:/work/SALOME-9.7.0/W64/protobuf/bin/protoc.exe -DProtobuf_PROTOC_LIBRARY=C:/work/SALOME-9.7.0/W64/protobuf/lib/libprotoc.lib -DSQLITE3_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/sqlite/include -DSQLITE3_LIBRARY=C:/work/SALOME-9.7.0/W64/sqlite/lib/sqlite3.lib -DZLIB_LIBRARY=C:/work/SALOME-9.7.0/W64/zlib/lib/zlib.lib -DZLIB_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/zlib/include -DPROJ_LIBRARY=C:/work/SALOME-9.7.0/W64/proj/lib/proj.lib -DPROJ_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/proj/include -DLIBXML2_LIBRARY=C:/work/SALOME-9.7.0/W64/libxml2/lib/xml2.lib -DLIBXML2_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/libxml2/include/libxml2 -DEXPAT_LIBRARY=C:/work/SALOME-9.7.0/W64/expat/lib/libexpat.lib -DEXPAT_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/expat/include -DQt5_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5 -DQt5WinExtras_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5WinExtras -DQt5LinguistTools_DIR=C:/work/SALOME-9.7.0/W64/qt/lib/cmake/Qt5LinguistTools -DQWT_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/qwt/include -DQWT_LIBRARY=C:/work/SALOME-9.7.0/W64/qwt/lib/qwt.lib -DQCA_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/qca/include/Qca-qt5/QtCrypto -DQCA_LIBRARY=C:/work/SALOME-9.7.0/W64/qca/lib/qca-qt5.lib -DEXIV2_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/exiv2/include -DEXIV2_LIBRARY=C:/work/SALOME-9.7.0/W64/exiv2/lib/exiv2.lib -DQTKEYCHAIN_LIBRARY=C:/work/SALOME-9.7.0/W64/qtkeychain/lib/qt5keychain.lib -DQTKEYCHAIN_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/qtkeychain/include/qt5keychain -DQSCINTILLA_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/qscintilla/include/qscintilla -DQSCINTILLA_LIBRARY=C:/work/SALOME-9.7.0/W64/qscintilla/lib/qscintilla.lib -DSPATIALITE_LIBRARY=C:/work/SALOME-9.7.0/W64/spatialite/lib/spatialite.lib -DSPATIALITE_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/spatialite/include/ -DSPATIALINDEX_INCLUDE_DIR=C:/work/SALOME-9.7.0/W64/spatialindex/include -DSPATIALINDEX_LIBRARY=C:/work/SALOME-9.7.0/W64/spatialindex/lib/spatialindex-64.lib -DWITH_QTWEBKIT=FALSE -DWITH_GEOREFERENCER=FALSE -DWITH_3D=OFF -DWITH_BINDINGS=OFF -DWITH_SERVER=OFF -DWITH_CUSTOM_WIDGETS=OFF -DWITH_QUICK=OFF -DWITH_QGIS_PROCESS=OFF -DWITH_POSTGRESQL=OFF -DENABLE_TESTS=OFF -DWITH_QSPATIALITE=OFF -DWITH_GRASS7=OFF && cmake --build . --config Release --target install

:: update launch script
cd /d C:\work
echo set PATH=%%out_dir_Path%%\W64\zlib\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\bzip2\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\libzip\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\minizip\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\expat\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\libxml2\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\openssl\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\sqlite\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\geos\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\protobuf\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\gdal\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\proj\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qt\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qtkeychain\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qwt\lib;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qca\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qca\lib\qca-qt5\crypto;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set QCA_PLUGIN_PATH=%%out_dir_Path%%\W64\qca\lib\qca-qt5 >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\exiv2\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\spatialite\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\spatialindex\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set PATH=%%out_dir_Path%%\W64\qgis\bin;%%PATH%% >> SALOME-9.7.0\env_launch.bat
echo set QGIS_PLUGINPATH=%%out_dir_Path%%\W64\qgis\plugins >> SALOME-9.7.0\env_launch.bat
echo set QGIS_PREFIX_PATH=%%out_dir_Path%%\W64\qgis >> SALOME-9.7.0\env_launch.bat
type SALOME-9.7.0\env_launch.bat

7z a SALOME-9.7.0.zip SALOME-9.7.0
