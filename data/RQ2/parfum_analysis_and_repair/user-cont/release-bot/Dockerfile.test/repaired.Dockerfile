FROM fedora:33

RUN dnf install -y git make python3-pip

ENV HOME=/home/test-user \
    PYTHONDONTWRITEBYTECODE=1

RUN useradd -u 1000 -d ${HOME} test-user

WORKDIR ${HOME}

COPY Makefile ./

COPY ./tests/ tests/
RUN chown -R 1000 ./

COPY . /tmp/tmp/
RUN cd /tmp/tmp/ && pip3 install --no-cache-dir ".[tests]" && rm -rf /tmp/tmp/

USER 1000

CMD make test
