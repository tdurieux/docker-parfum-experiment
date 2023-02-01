#
# Build stage
#
FROM ubuntu:20.04 AS build-stage

ARG DEBIAN_FRONTEND=noninteractive
# Install dependencies
RUN set -xe; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
		cmake make g++ protobuf-compiler patch \
		qtbase5-dev libqt5opengl5-dev libprotobuf-dev; \
	apt-get clean -y; \
	rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell /bin/bash default
WORKDIR /home/default

COPY . .
RUN set -xe; \
	mkdir build; \
	cd build; \
	cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo ..; \
	make simulator-cli -j $(nproc); \
	find . -maxdepth 1 ! -name 'bin' -exec rm -r {} \; ;

#
# Run stage
#
FROM ubuntu:20.04

LABEL maintainer="Robotics Erlangen e.V. <info@robotics-erlangen.de>"

ARG DEBIAN_FRONTEND=noninteractive
RUN set -xe; \
	apt-get update; \
	apt-get install --no-install-recommends -y \
		qtbase5-dev libqt5opengl5-dev libprotobuf-dev \
		tini; \
	apt-get clean -y; \
	rm -rf /var/lib/apt/lists/*;

RUN useradd --create-home --shell /bin/bash default
USER default
WORKDIR /home/default

COPY --chown=default:default /data/docker/simulatorcli_entrypoint.bash .
ENTRYPOINT ["tini", "--", "./simulatorcli_entrypoint.bash"]

COPY --chown=default:default --from=build-stage /home/default/COPYING .
COPY --chown=default:default --from=build-stage /home/default/COPYING.GPL .
COPY --chown=default:default --from=build-stage /home/default/config config
COPY --chown=default:default --from=build-stage /home/default/build build

# 10300: Control - Accepts simulator configuration commands
# 10301: Blue    - Accepts robot commands by the blue team
# 10302: Yellow  - Accepts robot commands by the yellow team