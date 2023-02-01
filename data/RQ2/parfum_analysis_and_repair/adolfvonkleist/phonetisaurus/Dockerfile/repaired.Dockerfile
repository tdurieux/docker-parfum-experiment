FROM python:3 as build

WORKDIR /build

RUN apt-get -y update && apt-get -y --no-install-recommends install git g++ autoconf-archive make libtool gfortran tar gawk && rm -rf /var/lib/apt/lists/*;

RUN wget https://www.openfst.org/twiki/pub/FST/FstDownload/openfst-1.6.2.tar.gz && \
    tar -xvzf openfst-1.6.2.tar.gz && \
    cd openfst-1.6.2 && \
    ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-static --enable-shared --enable-far --enable-ngram-fsts && \
    make -j $(nproc) && \
    make install && \
    ldconfig && rm openfst-1.6.2.tar.gz

RUN git clone https://github.com/mitlm/mitlm && \
	cd mitlm && \
	autoreconf -i && \
	./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" && \
	make -j $(nproc) && \
	make install

WORKDIR /build/phonetisaurus

COPY . ./

RUN pip3 install --no-cache-dir pybindgen

RUN ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" --enable-python && \
    make -j $(nproc) && \
    make install

FROM python:3-slim

RUN apt-get -y update && apt-get -y --no-install-recommends install gfortran && apt-get -y clean && apt-get -y autoclean && rm -rf /var/lib/apt/lists/*;

WORKDIR /setup

COPY --from=build /build/phonetisaurus/python ./
COPY --from=build /build/phonetisaurus/.libs/Phonetisaurus.so ./

RUN python setup.py install

COPY --from=build /usr/local/lib/fst /usr/local/lib/fst
COPY --from=build /usr/local/lib/libfst*so*0 /usr/local/lib/
COPY --from=build /usr/local/bin/phonetisaurus* /usr/local/bin/
COPY --from=build /build/phonetisaurus/src/scripts/* /usr/local/bin/
COPY --from=build /usr/local/bin/rnnlm /usr/local/bin/
COPY --from=build /usr/local/bin/estimate-ngram /usr/local/bin/
COPY --from=build /usr/local/lib/libmitlm.so.1.0.0 /usr/local/lib

RUN ldconfig

WORKDIR /work

ENTRYPOINT [ "/bin/bash" , "-c" ]
