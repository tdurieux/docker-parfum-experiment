FROM python:3.7
LABEL maintainer="James Turk <dev@jamesturk.net>"

ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONIOENCODING 'utf-8'
ENV LANG 'C.UTF-8'

RUN BUILD_DEPS=" \
      python3-dev \
      libpq-dev \
      wget \
    " \
    && apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS && rm -rf /var/lib/apt/lists/*;

ADD . /code/
WORKDIR /code/

RUN wget https://deb.nodesource.com/setup_lts.x -O nodesource.sh \
    && bash nodesource.sh \
    && apt install --no-install-recommends -y nodejs \
    && npm ci \
    && npm run build && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir -U pip poetry && poetry install

EXPOSE 8000
STOPSIGNAL SIGINT
ENTRYPOINT ["poetry", "run", "python", "-m", "bobsled.web"]
