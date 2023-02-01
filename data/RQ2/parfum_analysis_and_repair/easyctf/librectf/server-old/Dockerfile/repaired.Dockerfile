FROM python:3.8-slim

# RUN apk add build-base musl-dev libffi-dev mariadb-dev jpeg-dev
RUN apt-get update -y && apt-get install --no-install-recommends -y \
    build-essential \
    netcat \
    git \
    libffi-dev \
    libjpeg-dev \
    libmariadb-dev \
    libpng-dev \
    libssl-dev \
    openssh-client \
    python3 \
    python3-dev \
    python3-nose \
    python3-pip \
    systemd && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv

COPY Pipfile /
COPY Pipfile.lock /
RUN pipenv install --deploy --system

COPY . /app
WORKDIR /app
EXPOSE 80
ENV FLASK_APP=easyctf
ENTRYPOINT ["pipenv", "run", "/app/entrypoint.sh", "runserver"]
