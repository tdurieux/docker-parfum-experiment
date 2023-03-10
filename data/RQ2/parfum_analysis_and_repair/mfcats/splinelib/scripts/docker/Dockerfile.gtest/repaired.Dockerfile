# Build on top of spack
FROM christophsusen/spack

# Add code directory
ADD . /spackrepo
WORKDIR /spackrepo

RUN apt-get update && apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN mv ./scripts/docker/packages.yaml /root/.spack/linux/packages.yaml

# Install googletest versions
RUN spack repo add /spackrepo/scripts/spack-repo
RUN spack setup splinelib@github build_type=Debug %gcc@7
RUN spack setup splinelib@github build_type=Release %gcc@7
RUN spack setup splinelib@github build_type=Debug %clang@6
RUN spack setup splinelib@github build_type=Release %clang@6
RUN spack setup splinelib@github build_type=Debug %clang@5
RUN spack setup splinelib@github build_type=Release %clang@5
RUN spack setup splinelib@github build_type=Debug %gcc@8
RUN spack setup splinelib@github build_type=Release %gcc@8
RUN spack clean -a

CMD /bin/bash
