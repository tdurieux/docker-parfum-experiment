FROM mono:latest
EXPOSE 9000
COPY ./ /src
WORKDIR /src
RUN nuget restore && \
    find . -name "*RuntimeInformation.dll" -delete && \
    xbuild /p:Configuration=Debug && \
    find . -name "*RuntimeInformation.dll" -delete && \
    cp WebApp/WebAppConfig_dockerized_local.json WebApp/bin/Debug/WebAppConfig.json
WORKDIR /src/WebApp/bin/Debug
CMD mono WebApp.exe