FROM debian:buster
RUN apt-get update
RUN apt-get -y --no-install-recommends install build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libcurl4-openssl-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libedit-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install libjson-c-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /Connery
COPY src/. .
RUN cmake .
RUN cmake --build .
ENTRYPOINT "./Connery" && /bin/bash