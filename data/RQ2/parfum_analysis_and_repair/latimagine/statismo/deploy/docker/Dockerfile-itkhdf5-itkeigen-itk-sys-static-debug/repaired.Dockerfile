FROM ubuntu:bionic

ARG git_branch=develop

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -

RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

RUN apt-get install --no-install-recommends -y git cmake tar mesa-common-dev freeglut3-dev build-essential && rm -rf /var/lib/apt/lists/*;

# ITK system
WORKDIR "/usr/src/"
RUN git clone https://github.com/InsightSoftwareConsortium/ITK.git --branch v5.0.0 /usr/src/itk
WORKDIR "/usr/src/itk"
RUN mkdir build
WORKDIR "/usr/src/itk/build/"
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/src/itk/dist -DCMAKE_BUILD_TYPE=Debug -DBUILD_SHARED_LIBS=OFF -DBUILD_EXAMPLES=OFF -DBUILD_TESTING=OFF -DITK_BUILD_DEFAULT_MODULES=ON \
  -DModule_ITKReview=ON -DITK_LEGACY_REMOVE=ON -DITK_USE_SYSTEM_HDF5=OFF -DITK_USE_SYSTEM_EIGEN=OFF
RUN make -j4
RUN make install

# Statismo
RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /usr/src/statismo

WORKDIR "/usr/src/statismo"
RUN mkdir build
WORKDIR "/usr/src/statismo/build"

RUN cmake ../superbuild -DCMAKE_INSTALL_PREFIX=/usr/src/statismo/dist -DBUILD_TYPE=Debug -DBUILD_SHARED_LIBS=OFF -DBUILD_WRAPPING=OFF -DBUILD_DOCUMENTATION=OFF -DBUILD_CLI_TOOLS=OFF -DBUILD_CLI_TOOLS_DOC=OFF \
  -DVTK_SUPPORT=OFF -DUSE_SYSTEM_ITK=ON -DUSE_ITK_EIGEN=ON -DUSE_ITK_HDF5=ON -DITK_DIR=/usr/src/itk/dist/lib/cmake/ITK-5.0/

RUN make -j4

WORKDIR "/usr/src/statismo/build/Statismo-build"

RUN make install

# Tests
RUN ctest

# Test app
WORKDIR "/usr/src"
RUN mkdir statismo-demo
WORKDIR "/usr/src/statismo-demo"
RUN echo 'cmake_minimum_required(VERSION 3.15)\nproject(demo LANGUAGES CXX VERSION 0.1.0)\nfind_package(statismo REQUIRED)\ninclude(${STATISMO_USE_FILE})\nadd_executable(demo main.cpp)\ntarget_link_libraries(demo ${STATISMO_LIBRARIES} ${ITK_LIBRARIES})\n' > CMakeLists.txt
RUN echo "#include \"statismo/ITK/itkStandardMeshRepresenter.h\"\n#include <iostream>\nint main() {\nauto itkrep = itk::StandardMeshRepresenter<float, 3>::New();\nstd::cout << \"itk rep: \" << itkrep << std::endl;\nreturn 0;}\n" > main.cpp
RUN mkdir build
WORKDIR "/usr/src/statismo-demo/build"
RUN cmake .. -Dstatismo_DIR=/usr/src/statismo/dist/lib/cmake/statismo
RUN make
RUN ./demo
