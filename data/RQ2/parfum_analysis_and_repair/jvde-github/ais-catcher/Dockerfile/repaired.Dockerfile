# -------------------
# The build container
# -------------------
FROM debian:bullseye-slim AS build

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends git make gcc g++ cmake pkg-config -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends librtlsdr-dev libairspy-dev libhackrf-dev libairspyhf-dev libzmq3-dev libsoxr-dev -y && rm -rf /var/lib/apt/lists/*;

COPY . /root/AIS-catcher

RUN cd /root/AIS-catcher; mkdir build; cd build; cmake ..; make; make install

# -------------------------
# The application container
# -------------------------
FROM debian:bullseye-slim

RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get install --no-install-recommends librtlsdr0 libairspy0 libhackrf0 libairspyhf1 libzmq5 libsoxr0 -y && rm -rf /var/lib/apt/lists/*;

COPY --from=build /usr/local/bin/AIS-catcher /usr/local/bin/AIS-catcher

ENTRYPOINT ["/usr/local/bin/AIS-catcher"]
