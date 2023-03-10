FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

# Set-up shell
SHELL ["bash", "-c"]
ENV BASH_ENV /spack/bashrc

RUN spack repo add /code/scripts/spack-repo
RUN spack setup -v splinelib@github build_type=Release %gcc@8
RUN mkdir /code/build-acceptance
WORKDIR /code/build-acceptance
RUN ./../spconfig.py ..

# Install Splinelib
CMD make && ./test/AcceptanceTests