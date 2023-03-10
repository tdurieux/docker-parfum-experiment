FROM arm32v6/python:3.10-slim-buster as base

FROM base as builder
ENV PYTHONUNBUFFERED=1
ARG LIB_ARCH=arm
ARG RTSP_ARCH=armv6
# ARG FFMPEG_ARCH=${ARM:+armv7l}
RUN apt-get update \
    && apt-get install --no-install-recommends -y tar unzip curl jq g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --no-cache-dir --disable-pip-version-check --prefix=/build/usr/local -r /tmp/requirements.txt
COPY *.lib /tmp/lib/
RUN mkdir -p /build/app /build/tokens /build/img \
    && curl -f -L https://github.com/homebridge/ffmpeg-for-homebridge/releases/latest/download/ffmpeg-raspbian-armv6l.tar.gz \
    | tar xzf - -C /build \
    && RTSP_TAG=$( curl -f -s https://api.github.com/repos/aler9/rtsp-simple-server/releases/latest | jq -r .tag_name) \
    && echo -n $RTSP_TAG > /build/RTSP_TAG \
    && curl -f -L https://github.com/aler9/rtsp-simple-server/releases/download/${RTSP_TAG}/rtsp-simple-server_${RTSP_TAG}_linux_${RTSP_ARCH:-amd64}.tar.gz \
    | tar xzf - -C /build/app \
    && cp /tmp/lib/${LIB_ARCH:-amd}.lib /build/usr/local/lib/libIOTCAPIs_ALL.so \
    && rm -rf /tmp/*
COPY . /build/app/

FROM base
ENV PYTHONUNBUFFERED=1 RTSP_PROTOCOLS=tcp RTSP_READTIMEOUT=30s RTSP_READBUFFERCOUNT=2048 RTSP_LOGLEVEL=warn SDK_KEY=AQAAAIZ44fijz5pURQiNw4xpEfV9ZysFH8LYBPDxiONQlbLKaDeb7n26TSOPSGHftbRVo25k3uz5of06iGNB4pSfmvsCvm/tTlmML6HKS0vVxZnzEuK95TPGEGt+aE15m6fjtRXQKnUav59VSRHwRj9Z1Kjm1ClfkSPUF5NfUvsb3IAbai0WlzZE1yYCtks7NFRMbTXUMq3bFtNhEERD/7oc504b FLASK_APP=frontend
COPY --from=builder /build /
WORKDIR /app
CMD [ "flask", "run", "--host=0.0.0.0"]