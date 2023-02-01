# ref12/azdev-ingest-agent
FROM mcr.microsoft.com/dotnet/core/sdk:2.2 AS build
WORKDIR /bld

COPY . ./
#RUN dotnet restore Codex.sln

# copy everything else and build app
ENV RepackDebugInfo false
ENV DotNetCoreBuild true
WORKDIR /bld/src/Codex.Ingester
RUN dotnet publish -c Release -o /bld/out /bl:/logs/msbuild.binlog

# Get runtime container to copy dotnet binaries
FROM mcr.microsoft.com/dotnet/core/runtime:2.2 AS runtime

# Copy app and dotnet binaries to agent
FROM ref12/azdevagent AS agent
COPY --from=build /bld/out /codex