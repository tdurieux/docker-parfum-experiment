FROM mwader/static-ffmpeg:4.4.1 as ffmpeg

# Export packages from poetry and save
# to venv to avoid building them later
FROM python:3.10-slim-bullseye as compile
ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
COPY . .
RUN pip install --no-cache-dir poetry==1.1.12
RUN poetry export -o requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

FROM python:3.10-slim-bullseye as final
WORKDIR /app
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8
RUN mkdir -p /app/out
RUN mkdir -p /app/dl
# Copy FFMPEG Binaries
COPY --from=ffmpeg /ffmpeg /usr/local/bin/
COPY --from=ffmpeg /ffprobe /usr/local/bin/
COPY --from=ffmpeg /qt-faststart /usr/local/bin/
# Copy Venv
COPY --from=compile /opt/venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
# Copy in app files
COPY streamdl.py .
COPY entrypoint.sh .
ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
