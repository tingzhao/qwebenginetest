TEMPLATE = app

QT += webenginewidgets

unix {
  QMAKE_CXXFLAGS += -std=c++11
  macx {
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
    QMAKE_CXXFLAGS += -stdlib=libc++
  }
}

exists($${CONDA_ENV}) {
  message("Using conda $${CONDA_ENV}")
  INCLUDEPATH += $${CONDA_ENV}/include
  LIBS += -L$${CONDA_ENV}/lib
  unix: QMAKE_RPATHDIR *= $${CONDA_ENV}/lib
}

TARGET = qwebenginetest

SOURCES = main.cpp
