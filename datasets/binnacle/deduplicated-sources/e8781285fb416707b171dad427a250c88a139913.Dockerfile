FROM ubuntu:18.04 AS clone
WORKDIR /src
RUN apt-get update -y && apt-get install -y git && \ 
    git clone https://github.com/NethermindEth/nethermind && \
    cd nethermind && git submodule update --init
    
FROM microsoft/dotnet:2.2-sdk AS build
COPY --from=clone /src .
RUN cd nethermind/src/Nethermind/Nethermind.Runner && \
    dotnet publish -c release -o out

FROM microsoft/dotnet:2.2-aspnetcore-runtime
RUN apt-get update -y && apt-get install -y libsnappy-dev libc6-dev libc6 unzip

COPY --from=build /nethermind/src/Nethermind/Nethermind.Runner/out .

ENV ASPNETCORE_ENVIRONMENT docker
ENV NETHERMIND_CONFIG mainnet
ENV NETHERMIND_DETACHED_MODE true
ENV NETHERMIND_INITCONFIG_JSONRPCENABLED false
ENV NETHERMIND_URL http://*:8345

EXPOSE 8345 30312

ENTRYPOINT dotnet Nethermind.Runner.dll