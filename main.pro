TEMPLATE = app

QT += webenginewidgets

unix {
  QMAKE_CXXFLAGS += -std=c++11
  macx {
    QMAKE_MACOSX_DEPLOYMENT_TARGET = 10.9
    QMAKE_CXXFLAGS += -stdlib=libc++
  }
}

TARGET = qwebenginetest

SOURCES = main.cpp
