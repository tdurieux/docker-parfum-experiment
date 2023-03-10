FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Release %gcc@7
RUN mkdir /code/build-gcc7-release
WORKDIR /code/build-gcc7-release
RUN ../spconfig.py ..

# Build and execute tests
CMD make && ./test/SplineLibTests