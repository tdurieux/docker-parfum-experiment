# pull official base image
FROM python:3.8-slim

# install dependencies
RUN apt-get update && apt-get install --no-install-recommends -y apt-transport-https && \
    apt-get install --no-install-recommends -y libssl-dev libffi-dev gcc python3-dev musl-dev build-essential \
    libpq-dev netcat-openbsd && rm -rf /var/lib/apt/lists/*;

# set environment varibles
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# set working directory
WORKDIR /usr/src/app

# add and install requirements
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# add app
COPY . /usr/src/app
