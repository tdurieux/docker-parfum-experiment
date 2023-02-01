# (C) 2019 The Johns Hopkins University Applied Physics Laboratory LLC.

FROM ubuntu:20.04

ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get clean && \
    apt-get -y update && \
    apt-get -y --no-install-recommends install software-properties-common ca-certificates && rm -rf /var/lib/apt/lists/*;

RUN apt-get -y update && \
    apt-get -y --no-install-recommends install \
    wget \
    python3 \
    python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pipenv

RUN mkdir -p /nlp_webapp/
WORKDIR /nlp_webapp/

COPY client/Pipfile* client/
RUN cd client && pipenv install --dev --system --deploy
COPY test/Pipfile* tests/
RUN cd tests && pipenv install --dev --system --deploy

COPY client/ ./client/
COPY test/tests/pytest/ ./tests/pytest/
RUN ln -s /nlp_webapp/client/pine ./tests/
COPY test/docker/pytest/docker_run.sh ./docker_run.sh
COPY test/data/ ./data/

CMD ["./docker_run.sh"]
