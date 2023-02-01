# This is Dockerfile for development purposes only.
ARG PYTHON_VERSION='3.7'
FROM python:${PYTHON_VERSION}-slim
RUN mkdir /code /code/production
WORKDIR /code

# Install python dependencies