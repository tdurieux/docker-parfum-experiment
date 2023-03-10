FROM christophsusen/gtest

# Add current directory as working directory to docker
ADD . /code

RUN mkdir -p /code/build-clang-tidy
WORKDIR /code/build-clang-tidy

# Set-up shell
SHELL ["bash", "-c"]
ENV BASH_ENV /etc/profile.d/spack.sh

# Build and execute tests
RUN spack load googletest+gmock~shared%gcc@7 && cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=ON ../

# execute clang-tidy
CMD python ../scripts/run-clang-tidy.py /code/src/.* /code/test/.* | tee clang.log && grep -q -E "error:|warning:" clang.log && exit 1 || exit 0