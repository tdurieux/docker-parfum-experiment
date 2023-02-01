# ================================
# Build image
# ================================
FROM swift:5.4-focal as build
WORKDIR /build

# Perfect-COpenSSL
RUN apt-get -y update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

# Perfect-libcurl
RUN apt-get -y update && apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

# Perfect-LinuxBridge
RUN apt-get -y update && apt-get install --no-install-recommends -y uuid-dev && rm -rf /var/lib/apt/lists/*

# ImageMagick for creating raid images
RUN apt-get -y update && apt-get install --no-install-recommends -y imagemagick && cp /usr/bin/convert /usr/local/bin && rm -rf /var/lib/apt/lists/*;

# WGet
RUN apt-get -y update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# MySQL Client
RUN apt-get -y update && \
	apt-get install --no-install-recommends -y lsb-release mysql-client libmysqlclient-dev && \
	sed -i -e 's/-fabi-version=2 -fno-omit-frame-pointer//g' /usr/lib/x86_64-linux-gnu/pkgconfig/mysqlclient.pc && rm -rf /var/lib/apt/lists/*;

# Pre-Build
COPY Package.swift Package.swift
COPY .emptysources Sources
COPY .emptytests Tests
RUN swift package update
RUN swift build -c release -Xswiftc -g
RUN rm -rf Sources
RUN rm -rf Tests

# Build with optimizations
COPY Sources Sources
COPY Tests Tests
RUN swift build -c release -Xswiftc -g


# ================================
# Run image
# ================================
FROM swift:5.4-focal
WORKDIR /app

# Perfect-COpenSSL
RUN apt-get -y update && apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;

# Perfect-libcurl
RUN apt-get -y update && apt-get install --no-install-recommends -y libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;

# Perfect-LinuxBridge
RUN apt-get -y update && apt-get install --no-install-recommends -y uuid-dev && rm -rf /var/lib/apt/lists/*

# ImageMagick for creating raid images
RUN apt-get -y update && apt-get install --no-install-recommends -y imagemagick && cp /usr/bin/convert /usr/local/bin && rm -rf /var/lib/apt/lists/*;

# WGet
RUN apt-get -y update && apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;

# MySQL Client
RUN export DEBIAN_FRONTEND=noninteractive && \
	apt-get -y update && \
	apt-get install --no-install-recommends -y lsb-release mysql-client libmysqlclient-dev && \
	sed -i -e 's/-fabi-version=2 -fno-omit-frame-pointer//g' /usr/lib/x86_64-linux-gnu/pkgconfig/mysqlclient.pc && rm -rf /var/lib/apt/lists/*;

# Copy build artifacts
COPY --from=build /build/.build/release .
COPY resources resources
COPY Scripts Scripts
COPY .gitsha .
COPY .gitref .

RUN chmod +x ./Scripts/*

ENTRYPOINT ["./RealDeviceMapApp"]
