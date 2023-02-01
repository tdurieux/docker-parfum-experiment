FROM jrottenberg/ffmpeg:4.4-vaapi2004 as build-stage
FROM python:3-bullseye

COPY --from=build-stage /usr/local/bin /usr/local/bin
COPY --from=build-stage /usr/local/share /usr/local/share
COPY --from=build-stage /usr/local/include /usr/local/include
COPY --from=build-stage /usr/local/lib /usr/local/lib

WORKDIR /usr/src/app/tesla_dashcam

RUN apt-get update -y \
    && apt-get install --no-install-recommends -y \
        fonts-freefont-ttf \
        libnotify-bin \
        libva2 \
        libva-drm2 \
    && apt-get remove --purge --auto-remove -y && rm -rf /var/lib/apt/lists/*

ENV LIBRARY_PATH=/lib:/usr/lib

COPY . /usr/src/app/tesla_dashcam
RUN pip install --no-cache-dir -r requirements.txt

# Enable Logs to show on run
ENV PYTHONUNBUFFERED=true
# Provide a default timezone
ENV TZ=America/New_York

ENTRYPOINT [ "python3", "tesla_dashcam/tesla_dashcam.py" ]
