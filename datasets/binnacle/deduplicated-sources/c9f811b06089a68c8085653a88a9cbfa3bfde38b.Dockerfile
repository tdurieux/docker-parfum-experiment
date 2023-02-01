ARG baseimage

FROM $baseimage

ARG devpreviewurl=""
ARG country=""
ARG created=""

ENV CountryCode=$country DatabaseName=Financials$country DEVPREVIEWURL=$devpreviewurl

COPY ./importDevpreview.ps1 /Run/importDevpreview.ps1

RUN \Run\importDevpreview.ps1

LABEL created="$created" \
      country="$country"
