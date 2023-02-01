FROM ubuntu:18.04

RUN apt-get update && apt-get -y --no-install-recommends install \

    curl libcurl4 libssl1.0.0 zlib1g libicu60 libkrb5-3 liblttng-ust0 \

    build-essential gcc && rm -rf /var/lib/apt/lists/*;

ENV DOTNET_CLI_TELEMETRY_OPTOUT=1
RUN curl -f -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --version 3.0.100

ENV PATH="/root/.dotnet:${PATH}"
RUN dotnet --info

WORKDIR /src

CMD dotnet test