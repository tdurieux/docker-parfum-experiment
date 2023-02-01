FROM python:3.6-alpine


RUN apk update && \
    apk add --no-cache gcc \
            musl-dev \
            python3-dev


RUN python -m pip install -U pip && \
    python -m pip install pytest \
                          mypy \
                          flake8 \
                          typing


WORKDIR /code/
