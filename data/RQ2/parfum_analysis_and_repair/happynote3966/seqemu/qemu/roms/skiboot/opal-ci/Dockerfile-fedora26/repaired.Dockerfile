FROM fedora:26
RUN dnf -y install wget curl xterm gcc git xz make diffutils findutils expect valgrind valgrind-devel ccache dtc openssl-devel
RUN dnf -y install gcc-powerpc64-linux-gnu 
RUN dnf -y install http://public.dhe.ibm.com/software/server/powerfuncsim/p9/packages/v1.0-0/systemsim-p9-1.0-0.f22.x86_64.rpm
COPY . /build/
WORKDIR /build
ENTRYPOINT ./opal-ci/build-fedora24.sh