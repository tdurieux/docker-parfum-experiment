FROM buildpack-deps:jessie-scm

# Install .NET CLI dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6 \
        libcurl3 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu52 \
        liblttng-ust0 \
        libssl1.0.0 \
        libstdc++6 \
        libunwind8 \
        libuuid1 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
ENV DOTNET_SDK_VERSION 2.0.0-preview1-005977
ENV DOTNET_SDK_DOWNLOAD_URL https://dotnetcli.blob.core.windows.net/dotnet/Sdk/$DOTNET_SDK_VERSION/dotnet-dev-linux-x64.$DOTNET_SDK_VERSION.tar.gz

RUN curl -f -SL $DOTNET_SDK_DOWNLOAD_URL --output dotnet.tar.gz \
    && mkdir -p /usr/share/dotnet \
    && tar -zxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

# Trigger the population of the local package cache
ENV NUGET_XMLDOC_MODE skip
RUN mkdir warmup \
    && cd warmup \
    && dotnet new \
    && cd .. \
    && rm -rf warmup \
    && rm -rf /tmp/NuGetScratch

#################################################################
# Above is the Microsoft template, below is the app stuff:

# Setup folders
RUN mkdir -p /var/app
COPY src /var/app
WORKDIR /var/app

# Restore NuGet Packages and build both projects
RUN dotnet restore
RUN dotnet build

# Run the unit tests (very important! :D) and exit upon failures
RUN dotnet test Raffler.Tests

# All set, run the actual raffler!
CMD ["dotnet", "run", "-p", "Raffler/Raffler.csproj", "/var/names.txt"]
