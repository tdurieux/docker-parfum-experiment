# Image to use as the base for other containers
FROM ubuntu:18.04

# Setup CMake from kitware's repository (see details at https://apt.kitware.com/)
RUN apt-get update && apt-get install --no-install-recommends -y \
	apt-transport-https \
	ca-certificates \
	gnupg \
	software-properties-common \
	wget && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | \
	gpg --batch --dearmor - | \
	tee /etc/apt/trusted.gpg.d/kitware.gpg >/dev/null
RUN apt-add-repository 'deb https://apt.kitware.com/ubuntu/ bionic main'
RUN apt-get update && apt-get install --no-install-recommends -y \
	kitware-archive-keyring && rm -rf /var/lib/apt/lists/*;
RUN rm /etc/apt/trusted.gpg.d/kitware.gpg

# Install dependencies necessary to build project
RUN apt-get update && apt-get install --no-install-recommends -y \
	build-essential \
	cmake \
	autoconf \
	libtool \
	pkg-config \
	zlib1g-dev \
	libssl-dev \
	libmysqlclient-dev \
	uuid-dev && rm -rf /var/lib/apt/lists/*;

# Build common artifacts
COPY . /app

WORKDIR /app

COPY --from=builder /app/build build

RUN mkdir -p build && \
	cd build && \
	cmake /app && \
	make

CMD [ "true" ]
