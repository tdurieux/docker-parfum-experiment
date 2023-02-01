FROM microsoft/dotnet:1.0.1-preview2-sdk
ENV NUGET_XMLDOC_MODE skip
ARG CLRDBG_VERSION=VS2015U2
WORKDIR /clrdbg
RUN curl -SL https://raw.githubusercontent.com/Microsoft/MIEngine/getclrdbg-release/scripts/GetClrDbg.sh --output GetClrDbg.sh \
    && chmod 700 GetClrDbg.sh \
    && ./GetClrDbg.sh $CLRDBG_VERSION \
    && rm GetClrDbg.sh
WORKDIR /app
ENV ASPNETCORE_URLS http://*:5000
EXPOSE 5000
ENTRYPOINT ["/bin/bash", "-c", "if [ -z \"$REMOTE_DEBUGGING\" ]; then dotnet advanced.dll; else sleep infinity; fi"]
COPY . /app
