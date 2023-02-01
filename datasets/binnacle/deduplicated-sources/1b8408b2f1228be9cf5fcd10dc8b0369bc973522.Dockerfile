FROM aberaud/opendht-deps
MAINTAINER Adrien Béraud <adrien.beraud@savoirfairelinux.com>

COPY . /root/opendht
RUN cd /root/opendht && mkdir build && cd build \
	&& cmake -DCMAKE_INSTALL_PREFIX=/usr -DOPENDHT_PYTHON=On -DOPENDHT_LTO=On -DOPENDHT_TESTS=ON ..  \
	&& make -j8 && ./opendht_unit_tests && make install
