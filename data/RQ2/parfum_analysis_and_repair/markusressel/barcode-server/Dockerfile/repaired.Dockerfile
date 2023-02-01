# Docker image for barcode-server

FROM python:3.9

WORKDIR /app

COPY . .

RUN apt-get update \
 && apt-get -y --no-install-recommends install sudo && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip; \
    pip install --no-cache-dir pipenv; \
    pipenv install --system --deploy; \
    pip install --no-cache-dir .

ENV PUID=1000 PGID=1000

ENTRYPOINT [ "docker/entrypoint.sh", "barcode-server" ]
CMD [ "run" ]
