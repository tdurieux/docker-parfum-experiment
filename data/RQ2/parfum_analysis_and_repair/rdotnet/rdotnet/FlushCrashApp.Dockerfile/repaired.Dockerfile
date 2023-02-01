FROM r-base as base
RUN apt-get update; apt-get --assume-yes -y --no-install-recommends install gnupg; rm -rf /var/lib/apt/lists/*; \
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --batch --dearmor > microsoft.asc.gpg; \
    mv microsoft.asc.gpg /etc/apt/trusted.gpg.d/ ; \
    wget -q https://packages.microsoft.com/config/debian/9/prod.list ; \
    mv prod.list /etc/apt/sources.list.d/microsoft-prod.list  ; \
    apt-get update

RUN apt-get --assume-yes -y --no-install-recommends install dotnet-sdk-2.1 && rm -rf /var/lib/apt/lists/*;
WORKDIR /
COPY . .
RUN dotnet publish TestApps/FlushCrashApp/FlushCrashApp.csproj -c Release -o out
WORKDIR TestApps/FlushCrashApp/out/
ENV "R_HOME" "/usr/lib/R"
RUN [ "dotnet", "FlushCrashApp.dll" ]