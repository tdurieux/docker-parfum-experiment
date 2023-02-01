# This is a development dockerfile, that's made in 5 minutes by Amol Rama
# If it seems bad, feel free to let him know :)
FROM python:alpine

RUN apk update
RUN apk add --no-cache build-base sqlite openssl-dev libffi-dev tiff-dev jpeg-dev \
    openjpeg-dev zlib-dev freetype-dev lcms2-dev libwebp-dev tcl-dev tk-dev \
    harfbuzz-dev fribidi-dev libimagequant-dev libxcb-dev libpng-dev git

ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1
RUN pip install --no-cache-dir poetry yapf toml

WORKDIR /app

COPY pyproject.toml .

RUN poetry install

COPY . .

RUN poetry run python manage.py migrate
RUN poetry run python manage.py createsuperuser