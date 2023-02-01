FROM python:3.8-slim-bullseye

ENV PYTHONUNBUFFERED 1

RUN set -ex \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
      gcc \
      libffi-dev \
      libxslt-dev \
      musl-dev \
      gettext \
      nodejs \
      npm && rm -rf /var/lib/apt/lists/*;

COPY requirements /build

RUN pip install --no-cache-dir -r /build/development.txt

COPY package.json package-lock.json /build/

RUN npm install --prefix /build && npm cache clean --force;

COPY . /src

WORKDIR /src

RUN mv /build/node_modules ./

EXPOSE 8000

CMD ["gunicorn", "scope.wsgi:application", "-b=0:8000", "-k=gevent", "--reload"]
