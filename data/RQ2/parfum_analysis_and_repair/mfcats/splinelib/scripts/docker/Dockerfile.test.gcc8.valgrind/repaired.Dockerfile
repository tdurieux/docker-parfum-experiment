FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Debug %gcc@8
RUN mkdir /code/build-gcc8-valgrind
WORKDIR /code/build-gcc8-valgrind
RUN ../spconfig.py ..

# Build and execute tests
CMD make && valgrind ./test/SplineLibTests