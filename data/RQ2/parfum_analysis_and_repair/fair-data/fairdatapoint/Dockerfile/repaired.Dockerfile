FROM python:3-slim

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install git make curl && \
    useradd fdp && \
    mkdir /home/fdp && \
    chown fdp:fdp /home/fdp && rm -rf /var/lib/apt/lists/*;

COPY . /home/fdp

WORKDIR /home/fdp

RUN pip install --no-cache-dir . && \
    pip install --no-cache-dir gunicorn

ENV FDP_HOST=0.0.0.0
ENV FDP_PORT=80
EXPOSE 80

CMD fdp-run ${FDP_HOST} ${FDP_PORT}