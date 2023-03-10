FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Debug %gcc@8
RUN mkdir /code/build-gcc8-debug
WORKDIR /code/build-gcc8-debug
RUN ../spconfig.py ..

# Build and execute tests
CMD make && ./test/SplineLibTests