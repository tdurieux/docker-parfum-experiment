ARG CI_COMMIT_SHA
ARG CI_REGISTRY_IMAGE
FROM $CI_REGISTRY_IMAGE/build-debian-minimal:commit-$CI_COMMIT_SHA

# inherits from Dockerfile.build-debian-minimal
#
# just few extra dependencies for building IGT with all the optional components
# enabled

RUN apt-get update && apt-get install --no-install-recommends -y \
			libunwind-dev \
			libgsl-dev \
			libasound2-dev \
			libxmlrpc-core-c3-dev \
			libjson-c-dev \
			libcurl4-openssl-dev \
			python-docutils \
			valgrind \
			peg \
			libdrm-intel1 && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean
