ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
FROM $REPO:3.1-bionic-arm64v8

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core
RUN dotnet_version=3.1.7 \
    && curl -SL --output dotnet.tar.gz https://download.visualstudio.microsoft.com/download/pr/5d8bf507-759a-4cc6-92ae-8ef63478398a/6b298aad0f6ce04ebc09daa1007a4248/aspnetcore-runtime-3.1.7-linux-arm64.tar.gz \
    && dotnet_sha512='d5e97a7c3e495ffe03f62415802a5a6f8fc57e9ee86f7730e6752b016747514507fbf79c0e65a815b9d09fb35af05026ca8ea99626535b31703a217559909309' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet