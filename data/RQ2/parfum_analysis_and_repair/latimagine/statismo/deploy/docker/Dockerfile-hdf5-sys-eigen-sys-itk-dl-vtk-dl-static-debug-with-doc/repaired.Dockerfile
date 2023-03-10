FROM ubuntu:bionic

ARG git_branch=develop

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -

RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

RUN apt-get install --no-install-recommends -y git cmake tar valgrind pandoc doxygen mesa-common-dev freeglut3-dev build-essential && rm -rf /var/lib/apt/lists/*;

# Eigen system deployed with cmake
WORKDIR "/usr/src/"
RUN wget https://gitlab.com/libeigen/eigen/-/archive/3.3.5/eigen-3.3.5.tar.gz
RUN tar -xvzf eigen-3.3.5.tar.gz --one-top-level=eigen --strip-components 1 && rm eigen-3.3.5.tar.gz
WORKDIR "/usr/src/eigen"
RUN mkdir build
WORKDIR "/usr/src/eigen/build"
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/src/eigen/dist
RUN make install

# HDF5 system
WORKDIR "/usr/src/"
RUN wget https://www.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/hdf5-1.10.2/src/hdf5-1.10.2.tar.gz
RUN tar -xvzf hdf5-1.10.2.tar.gz --one-top-level=hdf5 --strip-components 1 && rm hdf5-1.10.2.tar.gz
WORKDIR "/usr/src/hdf5"
RUN mkdir build
WORKDIR "/usr/src/hdf5/build/"
RUN cmake .. -DCMAKE_INSTALL_PREFIX=/usr/src/hdf5/dist -DCMAKE_BUILD_TYPE=Debug -DHDF5_ENABLE_Z_LIB_SUPPORT=OFF -DHDF5_BUILD_CPP_LIB:BOOL=ON -DBUILD_SHARED_LIBS=OFF -DHDF5_BUILD_TOOLS=OFF -DBUILD_TESTING=OFF -DHDF5_BUILD_EXAMPLES=OFF -DHDF5_BUILD_JAVA=OFF
RUN make install

RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /usr/src/statismo

WORKDIR "/usr/src/statismo"
RUN mkdir build
WORKDIR "/usr/src/statismo/build"

RUN cmake ../superbuild -DCMAKE_INSTALL_PREFIX=/usr/src/statismo/dist -DBUILD_TYPE=Debug -DBUILD_SHARED_LIBS=OFF -DBUILD_WRAPPING=OFF -DBUILD_WITH_TIDY=OFF -DBUILD_DOCUMENTATION=ON -DBUILD_CLI_TOOLS=ON -DBUILD_CLI_TOOLS_DOC=ON \
  -DUSE_SYSTEM_EIGEN=ON -DUSE_SYSTEM_HDF5=ON -DEigen3_DIR=/usr/src/eigen/dist/share/eigen3/cmake -DHDF5_DIR=/usr/src/hdf5/dist/share/cmake/hdf5

# Build
RUN make -j4

WORKDIR "/usr/src/statismo/build/Statismo-build"

# Install
RUN make install

# Tests
# Some with and some without memcheck as runtime is too long
RUN ctest -V --timeout 3600 -D ExperimentalMemCheck -R "loggerTest|basicStatismoTest|utilsStatismoTest|itkStandardImageRepresenterTest|itkStandardMeshRepresenterTest|statismo-build-deformation-model-test-2d|statismo-sample-test-2d-image|statismo-reduce-model-test-2d|statismo-posterior-test-2d|statismo-build-deformation-model-test-3d|statismo-reduce-model-test-3d|statismo-posterior-test-3d|PosteriorModelBuilderTest|PCAModelBuilderWithSelfAdjointEigenSolverTest|PCAModelBuilderTest|vtkStandardImageRepresenterTest|vtkStandardMeshRepresenterTest"
RUN ctest --timeout 3600 -E "loggerTest|basicStatismoTest|utilsStatismoTest|itkStandardImageRepresenterTest|itkStandardMeshRepresenterTest|statismo-build-deformation-model-test-2d|statismo-sample-test-2d-image|statismo-reduce-model-test-2d|statismo-posterior-test-2d|statismo-build-deformation-model-test-3d|statismo-reduce-model-test-3d|statismo-posterior-test-3d|PosteriorModelBuilderTest|PCAModelBuilderWithSelfAdjointEigenSolverTest|PCAModelBuilderTest|vtkStandardImageRepresenterTest|vtkStandardMeshRepresenterTest"

# Test app
WORKDIR "/usr/src"
RUN mkdir statismo-demo
WORKDIR "/usr/src/statismo-demo"
RUN echo 'cmake_minimum_required(VERSION 3.15)\nproject(demo LANGUAGES CXX VERSION 0.1.0)\nfind_package(statismo REQUIRED)\ninclude(${STATISMO_USE_FILE})\nadd_executable(demo main.cpp)\ntarget_link_libraries(demo ${STATISMO_LIBRARIES} ${VTK_LIBRARIES} ${ITK_LIBRARIES})\n' > CMakeLists.txt
RUN echo "#include \"statismo/VTK/vtkStandardMeshRepresenter.h\"\n#include \"statismo/ITK/itkStandardMeshRepresenter.h\"\n#include <iostream>\nint main() {\nauto itkrep = itk::StandardMeshRepresenter<float, 3>::New();\nauto vtkrep = statismo::vtkStandardMeshRepresenter::SafeCreate();\nstd::cout << \"itk rep: \" << itkrep << std::endl;\nstd::cout << \"vtkrep rep: \" << vtkrep.get() << std::endl;\nreturn 0;}\n" > main.cpp
RUN mkdir build
WORKDIR "/usr/src/statismo-demo/build"
RUN cmake .. -Dstatismo_DIR=/usr/src/statismo/dist/lib/cmake/statismo
RUN make
RUN ./demo
