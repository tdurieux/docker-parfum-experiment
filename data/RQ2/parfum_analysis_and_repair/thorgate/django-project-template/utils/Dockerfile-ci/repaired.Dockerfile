FROM docker:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache python3 python3-dev build-base libffi-dev openssl-dev git bash rust cargo && \
    apk add --no-cache yq --repository http://dl-3.alpinelinux.org/alpine/edge/community/
RUN python3 -m ensurepip
RUN pip3 install --no-cache-dir docker-compose

ENV POETRY_HOME "$HOME/.poetry"
ENV POETRY_NO_INTERACTION 1
RUN wget https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py && \
    python3 get-poetry.py
ENV PATH="$POETRY_HOME/bin:$VENV_PATH/bin:$PATH"
