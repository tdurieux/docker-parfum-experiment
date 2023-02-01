FROM microsoft/dotnet:3.0-sdk
# https://github.com/dotnet/dotnet-docker/issues/618
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated libgdiplus libc6-dev vim \
     && rm -rf /var/lib/apt/lists/*
RUN mkdir /runner
WORKDIR /runner
COPY tests/project.csproj .
RUN dotnet restore project.csproj
