FROM python:alpine

WORKDIR /app

COPY app/requirements.txt /app

ARG TARGETOS
ENV targetos=$TARGETOS
ARG TARGETARCH
env targetarch=$TARGETARCH

RUN set -x \
    && apk update \
    && apk add curl jq \
    && mainurl="https://github.com/anchore/syft" \
    && latest_url="${mainurl}/releases/latest" \
    && latest_tag=$(curl -sL -H "Accept:application/json" $latest_url | jq -r .tag_name) \
    && latest_version=${latest_tag#v} \
    && download_url="${mainurl}/releases/download/${latest_tag}/syft_${latest_version}_${targetos}_${targetarch}.tar.gz" \
    && mkdir /tmp/syftdown \
    && curl -sL ${download_url} -o /tmp/syftdown/syft.tar.gz \
    && cd /tmp/syftdown \
    && tar -zxf /tmp/syftdown/syft.tar.gz \
    && mv /tmp/syftdown/syft /usr/local/bin \
    && apk del curl jq \
    && rm -fR /tmp/syftdown

RUN set -x \
      && apk update \
      && apk add gcc libpq-dev musl-dev  \
      && pip install -r requirements.txt \
      && apk del gcc

COPY app/* /app

CMD [ "python", "/app/sbomgen.py"]
