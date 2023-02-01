FROM python:3.8-slim-buster
WORKDIR /dslinter
COPY . .
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir pytest

# RUN pytest