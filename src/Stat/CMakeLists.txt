
if (BASICITERATIVESTATISTICS_FOUND)
  install(FILES MEDCouplingIterativeStatistics.py DESTINATION ${MEDCOUPLING_INSTALL_PYTHON})

  if (MEDCOUPLING_BUILD_PY_TESTS)
    add_subdirectory(Test)
  endif ()
endif ()
