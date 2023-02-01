########################################################################################################################
# shellcheck - lining for bash scrips
FROM nlknguyen/alpine-shellcheck:v0.4.6

COPY ./ ./

# Convert CRLF to CR as it causes shellcheck warnings.
RUN find . -type f -name '*.sh' -exec dos2unix {} \;

# Run shell check on all the shell files.
RUN find . -type f -name '*.sh' | wc -l && find . -type f -name '*.sh' | xargs shellcheck --external-sources

########################################################################################################################
# .NET Core 3.1
FROM mcr.microsoft.com/dotnet/core/sdk:3.1-alpine

ENV DOTNET_SKIP_FIRST_TIME_EXPERIENCE=true

RUN apk add --no-cache --update dos2unix

WORKDIR /work

# Copy just the solution and proj files to make best use of docker image caching.
COPY ./tesla-net.sln .
COPY ./src/Tesla.NET/Tesla.NET.csproj ./src/Tesla.NET/Tesla.NET.csproj
COPY ./test/Tesla.NET.Tests/Tesla.NET.Tests.csproj ./test/Tesla.NET.Tests/Tesla.NET.Tests.csproj

# Run restore on just the project files, this should cache the image after restore.
RUN dotnet restore

COPY . .

RUN dos2unix -k -q ./coverage.sh

RUN ./coverage.sh netcoreapp3.1 Debug
