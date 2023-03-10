FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Release %clang@6
RUN mkdir /code/build-clang6-release
WORKDIR /code/build-clang6-release
RUN ../spconfig.py ..

# Build and execute tests
CMD make && ./test/SplineLibTests