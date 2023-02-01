ARG baseimage

FROM $baseimage

ARG countryurl=""
ARG country=""
ARG created=""

ENV CountryCode=$country DatabaseName=Cronus$country COUNTRYURL=$countryurl

COPY ./importCountry.ps1 /Run/importCountry.ps1

RUN \Run\importCountry.ps1

LABEL created="$created" \
      country="$country"
