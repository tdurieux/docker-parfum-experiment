# Build time
# focal == ubuntu 2020.04
FROM ubuntu:focal as build

RUN apt update

RUN apt-get -y --no-install-recommends install g++ && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install ninja-build && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir conan==1.43.0# Match the version defined in Makefile deps:

COPY . /opt
WORKDIR /opt

RUN mkdir build
WORKDIR /opt/build
# We need to specify the compiler here or we'll have weird linking errors
RUN conan install -s compiler=gcc -s compiler.version=9 -s compiler.libcxx=libstdc++11 --build=missing ..
RUN cmake -GNinja -DCMAKE_BUILD_TYPE=MinSizeRel ..
RUN ninja install

# Runtime
FROM ubuntu:focal as runtime

RUN apt update
# Runtime
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-dev && rm -rf /var/lib/apt/lists/*; # necessary to include libpython
RUN apt-get install --no-install-recommends -y ca-certificates && rm -rf /var/lib/apt/lists/*;
RUN ["update-ca-certificates"]

# Debugging
RUN apt-get install --no-install-recommends -y strace && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y htop && rm -rf /var/lib/apt/lists/*;

RUN adduser --disabled-password --gecos '' app
COPY --chown=app:app --from=build /usr/local/bin/cobra_cli /usr/local/bin/cobra_cli
RUN chmod +x /usr/local/bin/cobra_cli
RUN ldd /usr/local/bin/cobra_cli

# Now run in usermode
USER app
WORKDIR /home/app

COPY --chown=app:app cli/cobraMetricsSample.json .

ENTRYPOINT ["cobra_cli"]
CMD ["--help"]
