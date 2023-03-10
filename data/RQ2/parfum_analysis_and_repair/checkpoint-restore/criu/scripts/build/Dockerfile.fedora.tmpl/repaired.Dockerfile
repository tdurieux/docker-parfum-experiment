ARG CC=gcc

COPY scripts/ci/prepare-for-fedora-rawhide.sh /bin/prepare-for-fedora-rawhide.sh
RUN /bin/prepare-for-fedora-rawhide.sh

COPY . /criu
WORKDIR /criu

RUN make mrproper && date && make -j $(nproc) CC="$CC" && date

# The rpc test cases are running as user #1000, let's add the user
RUN adduser -u 1000 test

RUN make -C test/zdtm -j $(nproc)