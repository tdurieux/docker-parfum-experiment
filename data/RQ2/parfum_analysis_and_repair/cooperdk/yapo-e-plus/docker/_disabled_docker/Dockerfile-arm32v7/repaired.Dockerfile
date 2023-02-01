FROM alpine AS qemu

#QEMU Download
ENV QEMU_URL https://github.com/balena-io/qemu/releases/download/v3.0.0%2Bresin/qemu-3.0.0+resin-arm.tar.gz
RUN apk add --no-cache curl && curl -f -L ${QEMU_URL} | tar zxvf - -C . --strip-components 1


FROM arm32v7/python:3.7.7-slim
# Add QEMU
COPY --from=qemu qemu-arm-static /usr/bin
RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends gcc git -y && rm -rf /var/lib/apt/lists/*;
# make a seperate layer for the ffmpeg related stuff
RUN apt-get install --no-install-recommends ffmpeg libavcodec58 libavformat58 libavresample4 libavutil56 python-numpy -y && rm -rf /var/lib/apt/lists/*;
COPY . /YAPO
WORKDIR /YAPO
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt
EXPOSE 8000
ENTRYPOINT ["/bin/bash", "/YAPO/startup.sh"]
