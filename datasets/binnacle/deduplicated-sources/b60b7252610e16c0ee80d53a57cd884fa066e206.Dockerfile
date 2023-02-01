FROM microsoft/dotnet:2.2-aspnetcore-runtime-stretch-slim  AS base
WORKDIR /app
RUN apt-get update && apt-get install libav-tools python2.7-minimal -y && cp /usr/bin/python2.7 /usr/bin/python
RUN curl -L https://yt-dl.org/downloads/latest/youtube-dl -o /usr/local/bin/youtube-dl && chmod a+rx /usr/local/bin/youtube-dl


FROM microsoft/dotnet:2.2-sdk-stretch AS build
WORKDIR /src
COPY *.sln ./
COPY DevWeek.Worker/DevWeek.Worker.csproj DevWeek.Worker/
RUN dotnet restore ./src-ci.sln
COPY . .
WORKDIR /src/DevWeek.Worker
RUN dotnet build -c Release -o /app

FROM build AS publish
RUN dotnet publish -c Release -o /app

FROM base AS final
WORKDIR /app
VOLUME /shared
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DevWeek.Worker.dll"]
