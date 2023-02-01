FROM alpine/flake8:3.8.4 AS clang-format-build

# Build dependencies
RUN apk update && apk add --no-cache git build-base ninja cmake python3

# Pass `--build-arg LLVM_TAG=master` for latest llvm commit
ARG LLVM_TAG
ENV LLVM_TAG ${LLVM_TAG:-llvmorg-8.0.0}

# Download and setup
WORKDIR /build
RUN git clone --branch ${LLVM_TAG} --depth 1 https://github.com/llvm/llvm-project.git
WORKDIR /build/llvm-project
RUN mv clang llvm/tools
RUN mv libcxx llvm/projects

# Build
WORKDIR llvm/build
RUN cmake -GNinja -DLLVM_BUILD_STATIC=ON -DLLVM_ENABLE_LIBCXX=ON ..
RUN ninja clang-format


FROM alpine/flake8:3.8.4

COPY --from=clang-format-build /build/llvm-project/llvm/build/bin/clang-format /usr/bin

ADD ./requirements.txt .

# Need to install build tools and auto-formatters
RUN apk add --no-cache git openssh build-base && \
    pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir -r requirements.txt

# Add in the .flake8 spec
ADD ./.flake8 /usr/local/lib/.flake8

# Add in the entry script
ADD ./run.sh /usr/local/bin/run.sh

# Make the code directory. It is expected that code is
#   loaded into here when beginning the checking process
RUN mkdir /code /code/src


# Add clang format configuration file
ADD ./.clang-format /code/.clang-format

#
# Default environment variables
#

# Don't do formatting automatically. Set to something
#   non-empty to perform formatting. Choose a single
#   available formatter for a default here. Black is the
#   only currently supported formater and therefor default
ENV DO_FORMAT=""
ENV FORMAT_BLACK="y"

# Do check automatically. Set to something empty
#   to turn off checking
ENV DO_CHECK="y"

# Don't hang automatically. This is useful for dev
#   purposes but shouldn't be turned on in prod
ENV DO_HANG=""

# Excludes
ENV FLAKE8_EXCLUDE=third-party,languages/python/third-party,languages/python/build
ENV BLACK_EXCLUDE=third-party|build
ENV ISORT_EXCLUDE="--skip third-party --skip build"

# Code to check
ENV CODE_DIR=/code

# Define the entrypoint -- need to override the default
ENTRYPOINT ["/usr/local/bin/run.sh"]

