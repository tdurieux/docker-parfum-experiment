ARG HASH

FROM core:$HASH as core-build

FROM ubuntu:20.04 AS csharp-interface-tests
ENV DEBIAN_FRONTEND=noninteractive

# Install essentials
RUN apt-get update
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# Install dotnet
RUN apt-get install --no-install-recommends -y gpg && rm -rf /var/lib/apt/lists/*;
RUN wget -O - https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor -o microsoft.asc.gpg
RUN mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/
RUN wget https://packages.microsoft.com/config/debian/10/prod.list
RUN mv prod.list /etc/apt/sources.list.d/microsoft-prod.list
RUN chown root:root /etc/apt/trusted.gpg.d/microsoft.asc.gpg
RUN chown root:root /etc/apt/sources.list.d/microsoft-prod.list
RUN apt-get update
RUN apt-get install --no-install-recommends -y apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN apt-get update
RUN apt-get install --no-install-recommends -y dotnet-sdk-3.1 && rm -rf /var/lib/apt/lists/*;

# Copy code
COPY clients/windows clients/windows
RUN mkdir -p /clients/windows/core/

WORKDIR /clients/windows/test
ENV API_URL=http://lockbook_server:8000

COPY --from=core-build /core/target/release/liblockbook_core.so /clients/windows/core

# Build tests
RUN dotnet build
