ARG AKTUALIZR_BASE=advancedtelematic/aktualizr-base
FROM $AKTUALIZR_BASE
LABEL Description="Aktualizr application dockerfile"

ADD . /aktualizr
WORKDIR /aktualizr/build

RUN cmake -DFAULT_INJECTION=on -DBUILD_SOTA_TOOLS=on -DBUILD_DEB=on -DCMAKE_BUILD_TYPE=Debug ..
RUN make -j8 install
RUN ldconfig