# This file has been automatically generated.

# The recipe below implements a Docker multi-stage build:
# <https://docs.docker.com/develop/develop-images/multistage-build/>

###############################################################################
# A first image to build the planner
###############################################################################
FROM ubuntu:18.04 AS builder

RUN apt-get update && apt-get install --no-install-recommends -y \
    ca-certificates \
    cmake           \
    g++             \
    git             \
    make            \
    python && rm -rf /var/lib/apt/lists/*;

WORKDIR /workspace/downward/

# Set up some environment variables.
ENV CXX g++

# Clone the desired tag into the current directory.
RUN git clone --depth 1 --branch release-19.06.0 https://github.com/aibasel/downward.git .

# Invoke the build script with default options.
RUN ./build.py
RUN strip --strip-all builds/release/bin/downward


###############################################################################
# The final image to run the planner
###############################################################################
FROM ubuntu:18.04 AS runner

RUN apt-get update && apt-get install --no-install-recommends -y \
    python  \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/downward/

# Copy the relevant files from the previous docker build into this build.
COPY --from=builder /workspace/downward/fast-downward.py .
COPY --from=builder /workspace/downward/builds/release/bin/ ./builds/release/bin/
COPY --from=builder /workspace/downward/driver ./driver

ENTRYPOINT ["/workspace/downward/fast-downward.py"]
