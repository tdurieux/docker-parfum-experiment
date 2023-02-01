FROM python:3.9-slim
RUN apt-get -y update && apt-get install --no-install-recommends -y wkhtmltopdf ffmpeg tzdata && pip3 install --no-cache-dir requests exif jellyfish && rm -rf /var/lib/apt/lists/*;
ENV TZ="America/Montevideo" \
    parameters="" \
    fileMask="*"
ADD . /BetterCovers
ENTRYPOINT sh /BetterCovers/src/scripts/start_container.sh