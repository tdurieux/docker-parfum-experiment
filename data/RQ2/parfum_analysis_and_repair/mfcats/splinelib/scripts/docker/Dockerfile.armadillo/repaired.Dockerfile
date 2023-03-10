FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code
WORKDIR /code

# Set-up shell
SHELL ["bash", "-c"]
ENV BASH_ENV /etc/profile.d/spack.sh

RUN spack install -v openblas %gcc@7
RUN spack install -v armadillo %gcc@7

CMD /bin/bash -l