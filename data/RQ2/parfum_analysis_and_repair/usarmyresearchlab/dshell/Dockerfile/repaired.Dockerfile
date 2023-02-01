FROM python:3-alpine as builder

COPY . /src

WORKDIR /src

ARG OUI_SRC="http://standards-oui.ieee.org/oui/oui.txt"

ENV VIRTUAL_ENV="/opt/venv"

RUN apk add --no-cache cargo curl g++ gcc rust libpcap-dev libffi-dev \
    && python3 -m venv "${VIRTUAL_ENV}" \
    && curl -f --location --silent --output "/src/dshell/data/oui.txt" "${OUI_SRC}"

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

RUN pip install --no-cache-dir --upgrade pip wheel && pip install --no-cache-dir .

FROM python:3-alpine

ENV VIRTUAL_ENV="/opt/venv"

COPY --from=builder "${VIRTUAL_ENV}/" "${VIRTUAL_ENV}/"

RUN apk add --no-cache bash libstdc++ libpcap

VOLUME ["/data"]

WORKDIR "/data"

ENV PATH="${VIRTUAL_ENV}/bin:${PATH}"

ENTRYPOINT ["dshell"]
