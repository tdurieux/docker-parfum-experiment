# pull official base image
FROM python:3.10.3-slim-buster

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install system dependencies
RUN apt-get update \
  && apt-get -y --no-install-recommends install netcat gcc postgresql \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# install dependencies
RUN pip install --no-cache-dir --upgrade pip
COPY ./requirements.txt .
COPY ./requirements-dev.txt .
RUN pip install --no-cache-dir -r requirements-dev.txt

# add app
COPY . .

# add entrypoint.sh
COPY ./entrypoint.sh .
RUN chmod +x /usr/src/app/entrypoint.sh
