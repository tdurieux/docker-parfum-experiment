ARG CORE_RUNTIME_TAG
ARG CORE_SDK_TAG
ARG CSPROJ_FILE
FROM mcr.microsoft.com/dotnet/core/runtime:${CORE_RUNTIME_TAG} AS base
WORKDIR /app

ARG CORE_SDK_TAG
ARG CSPROJ_FILE
FROM mcr.microsoft.com/dotnet/core/sdk:${CORE_SDK_TAG} AS build
WORKDIR /src
ARG CSPROJ_FILE
COPY [ "${CSPROJ_FILE}", "CCloud/CCloud.csproj"]
COPY ["Program.cs", "CCloud/"]
RUN dotnet restore "CCloud/CCloud.csproj"
COPY . .
WORKDIR "/src/CCloud"
RUN dotnet build "CCloud.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "CCloud.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "CCloud.dll"]