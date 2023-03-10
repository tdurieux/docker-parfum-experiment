FROM python:3.6-slim

# The source code for splitgraph goes here (root of the repository)
VOLUME /src/splitgraph

# The .sgconfig goes here, and its location should be set via env var
VOLUME /sgconfig

RUN apt-get update \
    && apt-get install --no-install-recommends -y curl git \
    && ( curl -f -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python) \
    && mkdir -p /src/splitgraph \
    && mkdir -p /sgconfig \
    && ( echo "alias poetry='/root/.poetry/bin/poetry'" >> /root/.bashrc ) \
    && ( echo "alias sgr='/root/.poetry/bin/poetry run sgr'" >> /root/.bashrc ) \
    && ( echo "alias pytest='/root/.poetry/bin/poetry run pytest -c /sgconfig/pytest.dev.ini'" >> /root/.bashrc ) && rm -rf /var/lib/apt/lists/*;

ADD docker-entrypoint-dev.sh /src/entrypoint.sh

WORKDIR /src/splitgraph

ENTRYPOINT ["sh", "/src/entrypoint.sh"]
