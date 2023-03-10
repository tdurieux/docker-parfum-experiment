# poetry-build: export poetry deps to requirements.txt
# this is seperate from backend-build so that poetry deps don't end
# among the python modules that will be copied to the final image
FROM python:3.9.0-slim as poetry-build
RUN python -m pip install -U pip poetry
WORKDIR /build
COPY oas_worker/pyproject.toml pyproject.toml
COPY oas_worker/poetry.lock poetry.lock
RUN poetry export -f requirements.txt --without-hashes -o /build/requirements.txt

# backend-build: install all python deps from requirements.txt to /build/pip
FROM python:3.9.0-slim as backend-build
RUN apt-get update && apt-get install --no-install-recommends -q -y gcc && rm -rf /var/lib/apt/lists/*;
WORKDIR /build
COPY --from=poetry-build /build/requirements.txt .
RUN pip install --no-cache-dir --prefix="/build/pip" --no-warn-script-location -r requirements.txt

# python-base: base image with a few utilities installed
FROM python:3.9.0-slim as python-base
RUN apt-get update && apt-get install --no-install-recommends -q -y wget curl xz-utils iputils-ping iproute2 && rm -rf /var/lib/apt/lists/*;

# build main image
FROM python-base
COPY --from=backend-build /build/pip/ /usr/local
# copy a static build of ffmpeg (this leads to a much smaller image
# than installing ffmpeg via apt)
COPY --from=mwader/static-ffmpeg:4.4.1 /ffmpeg /usr/local/bin/
COPY --from=mwader/static-ffmpeg:4.4.1 /ffprobe /usr/local/bin/
COPY oas_worker /app
WORKDIR /app
ENV STORAGE_PATH="/data"
CMD ["./start-worker-docker.sh"]
