FROM ubuntu:bionic

ARG git_branch=develop

RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https ca-certificates gnupg software-properties-common wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | apt-key add -

RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main' && apt-get update

RUN apt-get update \
  && apt-get install --no-install-recommends -y clang-6.0 clang-tidy-6.0 clang-format-6.0 python3-pip python3-dev git cmake mesa-common-dev freeglut3-dev swig build-essential \
  && cd /usr/local/bin \
  && ln -s /usr/bin/python3 python \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

RUN ln -s /usr/bin/clang-tidy-6.0 /usr/bin/clang-tidy
RUN ln -s /usr/bin/clang-format-6.0 /usr/bin/clang-format

# Statismo
RUN git clone https://github.com/kenavolic/statismo --branch $git_branch /usr/src/statismo

RUN clang-tidy --version

WORKDIR "/usr/src/statismo"

RUN mkdir build

WORKDIR "/usr/src/statismo/modules/VTK/wrapping"

RUN pip3 install --no-cache-dir -r requirements_tests.txt

WORKDIR "/usr/src/statismo/build"

RUN cmake ../superbuild -DAUTOBUILD_STATISMO=OFF -DBUILD_WITH_TIDY=ON -DBUILD_WRAPPING=ON -DBUILD_DOCUMENTATION=OFF -DBUILD_TYPE=Release -DBUILD_SHARED_LIBS=ON -DCMAKE_INSTALL_PREFIX=/usr/src/statismo/dist

# Build externals
RUN make -j4

# Build statismo with clang-tidy
WORKDIR "/usr/src/statismo/build/Statismo-build"
RUN if [ $(make -j4 2>&1 | grep -o 'warning:' | wc -l) -gt 6 ] ; then echo "too many warning, needs some tidy" && exit 1 ; fi

# Check format
RUN make format-check

# Install
RUN make install

# Tests
ENV PYTHONPATH "${PYTHONPATH}:/usr/src/statismo/dist/lib/python3.6/site-packages:/usr/src/statismo/build/INSTALL/lib/python3.6/site-packages"
ENV LD_LIBRARY_PATH "${LD_LIBRARY_PATH}:/usr/src/statismo/dist/lib:/usr/src/statismo/build/INSTALL/lib/"

RUN ctest

WORKDIR "/usr/src/statismo/modules/VTK/wrapping/tests/statismoTests"

RUN python3 -m unittest test_builders test_managers test_models

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
