FROM rust:1.45-stretch

# required by bingen
RUN apt-get update && \
	apt-get install --no-install-recommends -y \
		build-essential \
		cmake \
		clang-3.9 \
		libclang-3.9-dev \
		llvm-3.9-dev \
		gcc-arm-linux-gnueabi \
		g++-arm-linux-gnueabi \
		gcc-arm-linux-gnueabihf \
		g++-arm-linux-gnueabihf \
		gcc-aarch64-linux-gnu \
		g++-aarch64-linux-gnu \
		git && \
	apt-get clean && rm -rf /var/lib/apt/lists/*;

RUN rustup target add armv5te-unknown-linux-gnueabi
RUN rustup target add arm-unknown-linux-gnueabihf
RUN rustup target add aarch64-unknown-linux-gnu

RUN echo '[target.armv5te-unknown-linux-gnueabi]\n\
linker = "arm-linux-gnueabi-gcc"\n\
[target.arm-unknown-linux-gnueabihf]\n\
linker = "arm-linux-gnueabihf-gcc"\n\
[target.aarch64-unknown-linux-gnu]\n\
linker = "aarch64-linux-gnu-gcc"\n'\
>> /usr/local/cargo/config

RUN mkdir -p /tmp
RUN cd /tmp && git clone https://github.com/seife/opkg-utils.git && cd /tmp/opkg-utils && PREFIX=/usr make install

RUN mkdir -p /hal/native && \
	cd /hal/native && \
	git clone https://github.com/brocaar/lora_gateway.git -b v5.0.1r2 && \
	git clone https://github.com/brocaar/sx1302_hal.git -b V2.1.0r1 && \
	git clone https://github.com/Lora-net/gateway_2g4_hal.git -b V1.1.0

RUN cd /hal/native/lora_gateway && \
	make && \
	ln -s /hal/native/lora_gateway/libloragw/inc /usr/include/libloragw-sx1301 && \
	ln -s /hal/native/lora_gateway/libloragw/libloragw.a /usr/lib/libloragw-sx1301.a

RUN cd /hal/native/sx1302_hal && \
	make && \
	ln -s /hal/native/sx1302_hal/libloragw/inc /usr/include/libloragw-sx1302 && \
	ln -s /hal/native/sx1302_hal/libloragw/libloragw.a /usr/lib/libloragw-sx1302.a && \
	cp /hal/native/sx1302_hal/libtools/inc/* /usr/include && \
	cp /hal/native/sx1302_hal/libtools/*.a /usr/lib

RUN cd /hal/native/gateway_2g4_hal && \
	make && \
	ln -s /hal/native/gateway_2g4_hal/libloragw/inc /usr/include/libloragw-2g4 && \
	ln -s /hal/native/gateway_2g4_hal/libloragw/libloragw.a /usr/lib/libloragw-2g4.a

RUN mkdir -p /hal/armv5 && \
	cd /hal/armv5 && \
	git clone https://github.com/brocaar/lora_gateway.git -b v5.0.1r2 && \
	git clone https://github.com/brocaar/sx1302_hal.git -b V2.1.0r1 && \
	git clone https://github.com/Lora-net/gateway_2g4_hal.git -b V1.1.0

RUN mkdir -p /hal/armv7hf && \
	cd /hal/armv7hf && \
	git clone https://github.com/brocaar/lora_gateway.git -b v5.0.1r2 && \
	git clone https://github.com/brocaar/sx1302_hal.git -b V2.1.0r1 && \
	git clone https://github.com/Lora-net/gateway_2g4_hal.git -b V1.1.0

RUN mkdir -p /hal/aarch64 && \
	cd /hal/aarch64 && \
	git clone https://github.com/brocaar/lora_gateway.git -b v5.0.1r2 && \
	git clone https://github.com/brocaar/sx1302_hal.git -b V2.1.0r1 && \
	git clone https://github.com/Lora-net/gateway_2g4_hal.git -b V1.1.0

# Needed for RAK shields, works with other shields too
# RUN sed -i 's/define SPI_SPEED.*/define SPI_SPEED 2000000/g' /hal/armv5/lora_gateway/libloragw/src/loragw_spi.native.c
# RUN sed -i 's/define SPI_SPEED.*/define SPI_SPEED 2000000/g' /hal/armv7hf/lora_gateway/libloragw/src/loragw_spi.native.c

RUN cd /hal/armv5/lora_gateway && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make && \
	ln -s /hal/armv5/lora_gateway/libloragw/inc /usr/arm-linux-gnueabi/include/libloragw-sx1301 && \
	ln -s /hal/armv5/lora_gateway/libloragw/libloragw.a /usr/arm-linux-gnueabi/lib/libloragw-sx1301.a

RUN cd /hal/armv5/sx1302_hal && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make && \
	ln -s /hal/armv5/sx1302_hal/libloragw/inc /usr/arm-linux-gnueabi/include/libloragw-sx1302 && \
	ln -s /hal/armv5/sx1302_hal/libloragw/libloragw.a /usr/arm-linux-gnueabi/lib/libloragw-sx1302.a && \
	cp /hal/armv5/sx1302_hal/libtools/inc/* /usr/arm-linux-gnueabi/include && \
	cp /hal/armv5/sx1302_hal/libtools/*.a /usr/arm-linux-gnueabi/lib

RUN cd /hal/armv5/gateway_2g4_hal && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- make && \
	ln -s /hal/armv5/gateway_2g4_hal/libloragw/inc /usr/arm-linux-gnueabi/include/libloragw-2g4 && \
	ln -s /hal/armv5/gateway_2g4_hal/libloragw/libloragw.a /usr/arm-linux-gnueabi/lib/libloragw-2g4.a

RUN cd /hal/armv7hf/lora_gateway && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make && \
	ln -s /hal/armv7hf/lora_gateway/libloragw/inc /usr/arm-linux-gnueabihf/include/libloragw-sx1301 && \
	ln -s /hal/armv7hf/lora_gateway/libloragw/libloragw.a /usr/arm-linux-gnueabihf/lib/libloragw-sx1301.a

RUN cd /hal/armv7hf/sx1302_hal && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make && \
	ln -s /hal/armv7hf/sx1302_hal/libloragw/inc /usr/arm-linux-gnueabihf/include/libloragw-sx1302 && \
	ln -s /hal/armv7hf/sx1302_hal/libloragw/libloragw.a /usr/arm-linux-gnueabihf/lib/libloragw-sx1302.a && \
	cp /hal/armv7hf/sx1302_hal/libtools/inc/* /usr/arm-linux-gnueabihf/include && \
	cp /hal/armv7hf/sx1302_hal/libtools/*.a /usr/arm-linux-gnueabihf/lib

RUN cd /hal/armv7hf/gateway_2g4_hal && \
	ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make && \
	ln -s /hal/armv7hf/gateway_2g4_hal/libloragw/inc /usr/arm-linux-gnueabihf/include/libloragw-2g4 && \
	ln -s /hal/armv7hf/gateway_2g4_hal/libloragw/libloragw.a /usr/arm-linux-gnueabihf/lib/libloragw-2g4.a

RUN cd /hal/aarch64/lora_gateway && \
	ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- make && \
	ln -s /hal/aarch64/lora_gateway/libloragw/inc /usr/aarch64-linux-gnu/include/libloragw-sx1301 && \
	ln -s /hal/aarch64/lora_gateway/libloragw/libloragw.a /usr/aarch64-linux-gnu/lib/libloragw-sx1301.a

RUN cd /hal/aarch64/sx1302_hal && \
	ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- make && \
	ln -s /hal/aarch64/sx1302_hal/libloragw/inc /usr/aarch64-linux-gnu/include/libloragw-sx1302 && \
	ln -s /hal/aarch64/sx1302_hal/libloragw/libloragw.a /usr/aarch64-linux-gnu/lib/libloragw-sx1302.a && \
	cp /hal/aarch64/sx1302_hal/libtools/inc/* /usr/aarch64-linux-gnu/include && \
	cp /hal/aarch64/sx1302_hal/libtools/*.a /usr/aarch64-linux-gnu/lib

RUN cd /hal/aarch64/gateway_2g4_hal && \
	ARCH=arm CROSS_COMPILE=aarch64-linux-gnu- make && \
	ln -s /hal/aarch64/gateway_2g4_hal/libloragw/inc /usr/aarch64-linux-gnu/include/libloragw-2g4 && \
	ln -s /hal/aarch64/gateway_2g4_hal/libloragw/libloragw.a /usr/aarch64-linux-gnu/lib/libloragw-2g4.a

ENV LLVM_CONFIG_PATH=llvm-config-3.9
ENV PROJECT_PATH=/chirpstack-concentratord
RUN mkdir -p $PROJECT_PATH
WORKDIR $PROJECT_PATH

COPY . /chirpstack-concentratord
RUN cargo fetch
