FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

# Set-up shell
SHELL ["bash", "-c"]
ENV BASH_ENV /etc/profile.d/spack.sh

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Release %gcc@8
RUN mkdir /code/build-install
WORKDIR /code/build-install
RUN ./../spconfig.py ..

# Install Splinelib
RUN make install

RUN mkdir /code/example/build
WORKDIR /code/example/build

RUN spack load splinelib@github build_type=Release %gcc@8 && cmake ../
RUN make

CMD spack load splinelib@github build_type=Release %gcc@8 && ./ex1