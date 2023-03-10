FROM ubuntu:21.04 AS build

RUN apt-get update -qq \
    && apt-get install --no-install-recommends -y clang && rm -rf /var/lib/apt/lists/*;

WORKDIR /opt/app
COPY *.cpp .
RUN clang++ -march=native -mtune=native -Ofast -std=c++17 PrimeCPP.cpp -o PrimeCPP

FROM ubuntu:21.04
COPY --from=build /opt/app/PrimeCPP /usr/local/bin

ENTRYPOINT [ "PrimeCPP" ]