FROM debian:bullseye AS build
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y gcc g++ make cmake libssl-dev && rm -rf /var/lib/apt/lists/*;
COPY libdatachannel /src/
WORKDIR /src
RUN cmake -B build
WORKDIR /src/build
RUN make -j4
FROM debian:bullseye AS final
RUN apt-get update
RUN DEBIAN_FRONTEND="noninteractive" apt-get --no-install-recommends install -y libstdc++6 libssl1.1 && rm -rf /var/lib/apt/lists/*;
WORKDIR /app
COPY --from=build /src/build/client .
COPY --from=build /src/build/server .
COPY html ../html/
COPY libdatachannel/client.sh /client.sh
RUN chmod +x /client.sh
EXPOSE 8080
ENTRYPOINT /app/server

