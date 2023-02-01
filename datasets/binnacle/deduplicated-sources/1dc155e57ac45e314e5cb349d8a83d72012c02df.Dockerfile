FROM microsoft/dotnet:2.1-aspnetcore-runtime AS base
WORKDIR /app
EXPOSE 80

FROM base as withnode
ENV NODE_VERSION 8.11.1
ENV NODE_DOWNLOAD_SHA 0e20787e2eda4cc31336d8327556ebc7417e8ee0a6ba0de96a09b0ec2b841f60
RUN curl -SL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY "SmartHotel.FacilityManagementWeb/*" "/src/"
RUN dotnet restore "SmartHotel.FacilityManagementWeb.csproj"
COPY . .
WORKDIR "/src/SmartHotel.FacilityManagementWeb/"
RUN dotnet build SmartHotel.FacilityManagementWeb.csproj -c Release -o /webapp

ENV NODE_VERSION 8.11.1
ENV NODE_DOWNLOAD_SHA 0e20787e2eda4cc31336d8327556ebc7417e8ee0a6ba0de96a09b0ec2b841f60
RUN curl -SL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz" --output nodejs.tar.gz \
    && echo "$NODE_DOWNLOAD_SHA nodejs.tar.gz" | sha256sum -c - \
    && tar -xzf "nodejs.tar.gz" -C /usr/local --strip-components=1 \
    && rm nodejs.tar.gz \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs
FROM build AS publish
	
WORKDIR "/src/SmartHotel.FacilityManagementWeb/ClientApp"
RUN npm install -g @angular/cli@1.7.0

WORKDIR "/src/SmartHotel.FacilityManagementWeb/"
RUN dotnet publish SmartHotel.FacilityManagementWeb.csproj -c Release -o /webapp


FROM withnode AS final
WORKDIR /app

COPY --from=publish /webapp .
ENTRYPOINT ["dotnet", "SmartHotel.FacilityManagementWeb.dll"]
