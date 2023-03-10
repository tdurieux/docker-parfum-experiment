FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Debug %clang@5
RUN mkdir /code/build-clang5-debug
WORKDIR /code/build-clang5-debug
RUN ../spconfig.py ..

# Build and execute tests
CMD make && ./test/SplineLibTests