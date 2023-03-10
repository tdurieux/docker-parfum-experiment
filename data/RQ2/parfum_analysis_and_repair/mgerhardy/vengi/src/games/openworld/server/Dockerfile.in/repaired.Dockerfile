FROM debian:bullseye as builder
MAINTAINER Martin Gerhardy <martin.gerhardy@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
	apt-get update -q && \
	apt-get install --no-install-recommends -y \
		cmake \
		g++ \
		pkg-config \
		ninja-build \
		opencl-c-headers \
		postgresql-server-dev-all \
		libncurses-dev \
		uuid-dev \
		ocl-icd-libopencl1 \
		&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

ARG TARGETDIR=/tmp/@ROOT_PROJECT_NAME@
RUN mkdir ${TARGETDIR}
COPY . ${TARGETDIR}

RUN mkdir ${TARGETDIR}/build
RUN --mount=type=cache,target=${TARGETDIR}/build \
	cmake -H${TARGETDIR} -B${TARGETDIR}/build -GNinja -DCMAKE_BUILD_TYPE=Release && \
	cmake --build ${TARGETDIR}/build --target server && \
	cmake --install ${TARGETDIR}/build --component server --prefix installation

FROM debian:bullseye
ARG TARGETDIR=/tmp/@ROOT_PROJECT_NAME@

RUN \
	apt-get update -q && \
	apt-get install --no-install-recommends -y \
		libatomic1 \
		libpq5 \
		ocl-icd-libopencl1 \
		uuid-runtime \
		libncurses6 \
		&& \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN mkdir -p /opt/@ROOT_PROJECT_NAME@/
COPY --from=builder ${TARGETDIR}/build/@PROJECT_NAME@ /opt/@ROOT_PROJECT_NAME@/

ENV SV_POSTGRESLIB=libpq.so.5
ENV CON_CURSES=0
EXPOSE @SERVER_PORT@

WORKDIR /opt/@ROOT_PROJECT_NAME@
ENTRYPOINT ./@ROOT_PROJECT_NAME@-@PROJECT_NAME@
