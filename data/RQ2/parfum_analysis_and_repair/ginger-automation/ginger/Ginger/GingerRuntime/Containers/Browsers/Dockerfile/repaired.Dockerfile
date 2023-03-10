#Build and deploy one time with latest dependencies and another time use version specific dependenecies
#FROM ghcr.io/ginger-automation/gingerruntime:latest
#FROM ghcr.io/ginger-automation/gingerruntime:4.2

FROM ghcr.io/ginger-automation/gingerruntime:4.2

USER root

RUN apk add --no-cache firefox

RUN apk add --no-cache chromium
RUN apk add --no-cache chromium-chromedriver

ENV CHROME_BIN=/usr/bin/chromium-browser \
    CHROME_PATH=/usr/lib/chromium/

RUN export PATH=$PATH:/usr/lib/chromium/

USER guest

WORKDIR /GingerRuntime
ENTRYPOINT ["dotnet", "GingerRuntime.dll"]