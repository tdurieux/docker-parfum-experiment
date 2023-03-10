FROM ubuntu:18.04
LABEL maintainer "Chris Ohk <utilforever@gmail.com>"

RUN apt-get update && apt-get install -y \
    build-essential \
    python-dev \
    python-pip \
    python3-dev \
    python3-pip \
    python3-venv \
    cmake \
    lcov \
    --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY . /app

WORKDIR /app/ENV3
RUN cd .. && \
    pip3 install --no-cache-dir -r requirements.txt && \
    pip3 install --no-cache-dir . && \
    python3 -m pytest ./Tests/PythonTests

WORKDIR /app/build
RUN cmake .. -DCMAKE_BUILD_TYPE=Debug -DBUILD_COVERAGE=ON && \
    make -j "$(nproc)" UnitTests && \
    lcov -c -i -d Tests/UnitTests -o base.info && \
    bin/UnitTests && \
    lcov -c -d Tests/UnitTests -o test.info && \
    lcov -a base.info -a test.info -o coverage.info && \
    lcov -r coverage.info '/usr/*' -o coverage.info && \
    lcov -r coverage.info '*/Extensions/*' -o coverage.info && \
    lcov -r coverage.info '*/Includes/*' -o coverage.info && \
    lcov -r coverage.info '*/Libraries/*' -o coverage.info && \
    lcov -l coverage.info
