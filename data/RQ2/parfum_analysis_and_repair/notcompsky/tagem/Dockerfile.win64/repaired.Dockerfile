# Has to be in the root directory, otherwise the docker build system will not allow copying the necessary files from the host to the container

FROM notcompsky/mxe_amd64-mysql-ffmpeg:latest AS intermediate
WORKDIR /tagem

COPY ffmpegthumbnailer-static.patch /ffmpegthumbnailer-static.patch
COPY server /tagem/server
COPY utils /tagem/utils

ARG libmagic_version=5.39
ARG python_version=3.9.1

RUN apt update \
	&& apt install --no-install-recommends -y curl git tar sed python3 \

	&& cd /mxe \
	&& make libgnurx \

	&& echo "First make Python of the same version for the host, which is required to cross-compile Python" \
	&& curl -f -s https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz \
	| tar xz \
	&& cd Python-${python_version} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
	&& make altinstall \

	&& curl -f -s https://www.python.org/ftp/python/${python_version}/Python-${python_version}.tgz \
	| tar xz \
	&& cd Python-${python_version} \
	&& sed -i 's+/* Compiler specific defines */+#define MS_WIN64+g' PC/pyconfig.h \
	&& ./configure \
		--host=x86_64-w64-mingw32 \
		--build=x86_64-pc-linux-gnu \
		--enable-static \
		--disable-shared \
	&& make \
	&& make install \

	&& mkdir py \
	&& cd py \
	&& curl -f -s https://www.python.org/ftp/python/${python_version}/python-${python_version}-embed-amd64.zip > py.zip \
	&& unzip py.zip \
	&& mv python39.dll /usr/lib/python3.9.a \

	&& git clone --depth 1 https://github.com/lexbor/lexbor \

	&& curl -f -s ftp://ftp.astron.com/pub/file/file-${libmagic_version}.tar.gz | tar -xz \
	&& cd file-${libmagic_version} \
	&& ./configure --build="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \
		--enable-static \
		--disable-shared \
		--host=x86_64-w64-mingw32.static \
	&& ( \
		make && make install || ( \
			echo "Tries to build linked executable despite options" \
			&& mv src/.libs/libmagic.a /usr/local/lib/libmagic.a \
			&& mv src/magic.h /usr/local/include/magic.h \
		) \
	) \

	&& git clone --depth 1 https://github.com/Tencent/rapidjson \
	&& mv rapidjson/include/rapidjson /usr/include/rapidjson \

	&& git clone --depth 1 https://github.com/dirkvdb/ffmpegthumbnailer \
	&& cd ffmpegthumbnailer \
	&& git apply /ffmpegthumbnailer-static.patch \
	&& addlocalinclude() { \
		mv CMakeLists.txt CMakeLists.old.txt \
		&& echo 'include_directories("/usr/local/include" "/usr/include")' > CMakeLists.txt \
		&& cat CMakeLists.old.txt >> CMakeLists.txt \
		; \
	} \
	&& addlocalinclude \
	&& mkdir build \
	&& cd build \
	&& x86_64-w64-mingw32.static-cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES=/FFmpeg \
		-DENABLE_SHARED=OFF \
		-DENABLE_STATIC=ON \
		-DENABLE_TESTS=OFF .. \
	&& make install \
	\
	&& git clone --depth 1 https://github.com/NotCompsky/libcompsky \
	&& cd libcompsky \
	&& addlocalinclude \
	&& mkdir build \
	&& cd build \
	&& x86_64-w64-mingw32.static-cmake \
		-DCMAKE_BUILD_TYPE=Release \
		-DMYSQL_IS_UNDER_MARIADB_DIR=1 \
		-DMYSQL_UNDER_DIR_OVERRIDE=1 \
		.. \
	&& make install \
	\
	&& cd /tagem/lexbor \
	&& x86_64-w64-mingw32.static-cmake \
		-DLEXBOR_BUILD_SHARED=OFF \
		-DLEXBOR_BUILD_STATIC=ON \
		-DLEXBOR_BUILD_TESTS=OFF \
		-DLEXBOR_BUILD_TESTS_CPP=OFF \
		-DLEXBOR_BUILD_UTILS=OFF \
		-DLEXBOR_BUILD_EXAMPLES=OFF \
		-DLEXBOR_BUILD_SEPARATELY=ON \
		. \
	&& make \
	&& make install \
	\
	&& mv /usr/include/python3.8/* /usr/include/ \
	\
	&& chmod +x /tagem/server/scripts/* \
	&& ( \
		rm -rf /tagem/build \
		;  mkdir /tagem/build \
	) && cd /tagem/server \
	&& addlocalinclude \
	&& cd /tagem/build \
	&& LD_LIBRARY_PATH="/usr/local/lib64:$LD_LIBRARY_PATH" cmake \
		\
		-DCMAKE_BUILD_TYPE=Release \
		-DENABLE_STATIC=ON \
		-DEMBED_PYTHON=ON \
		/tagem/server \
	&& make server && rm -rf /var/lib/apt/lists/*;

FROM alpine:latest
COPY --from=intermediate /tagem/build/server /tagem-server
