FROM debian:buster

RUN apt-get update && apt-get -y --no-install-recommends install git g++ cmake pkg-config flex bison python3 python3-pip ninja-build qt5-default libqt5svg5-dev qttools5-dev && \
	pip3 install --no-cache-dir meson && rm -rf /var/lib/apt/lists/*;

RUN cd /root && \
	git clone --depth 1 https://github.com/rizinorg/rizin && \
	cd rizin && \
	meson build --prefix=/usr && \
	ninja -C build && \
	ninja -C build install

RUN cd /root && \
	git clone --recurse-submodules --depth 1 https://github.com/rizinorg/cutter && \
	cd cutter && \
	cmake -Bbuild -GNinja -DCUTTER_USE_BUNDLED_RIZIN=OFF -DCMAKE_INSTALL_PREFIX=/usr && \
	ninja -C build && \
	ninja -C build install

CMD []

