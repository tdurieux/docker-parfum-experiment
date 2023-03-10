#This docker builds a container for the LoRa Basics station on amd64 architecture

# NOTE: Use either docker.io or your own registry address to build the image
ARG SOURCE_CONTAINER_REGISTRY_ADDRESS=your-registry-address.azurecr.io
FROM $SOURCE_CONTAINER_REGISTRY_ADDRESS/amd64/debian:buster as build
RUN apt-get update
RUN apt-get install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN apt-get install -y --no-install-recommends apt-utils build-essential && rm -rf /var/lib/apt/lists/*;
RUN git clone --branch v2.0.6 --single-branch --depth 1 https://github.com/lorabasics/basicstation.git
WORKDIR /basicstation

RUN make platform=linux variant=std

FROM $SOURCE_CONTAINER_REGISTRY_ADDRESS/amd64/debian:buster-slim
WORKDIR /basicstation
COPY --from=build /basicstation/build-linux-std/bin/station ./station.std
COPY LoRaEngine/modules/LoRaBasicsStationModule/helper-functions.sh .
COPY LoRaEngine/modules/LoRaBasicsStationModule/start_basicsstation.sh .
COPY LoRaEngine/modules/LoRaBasicsStationModule/sx1301.station.conf .
COPY --from=build /basicstation/deps/lgw/platform-linux/reset_lgw.sh .
COPY LICENSE .
COPY ./LoRaEngine/modules/LoRaBasicsStationModule/NOTICE.txt .
RUN chmod +x ./start_basicsstation.sh
ENTRYPOINT ["./start_basicsstation.sh"]
