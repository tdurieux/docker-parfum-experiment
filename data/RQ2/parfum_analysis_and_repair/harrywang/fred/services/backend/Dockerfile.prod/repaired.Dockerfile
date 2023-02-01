# pull official base image
FROM python:3.8.1-slim

# install netcat
RUN apt-get update && \
    apt-get -y --no-install-recommends install netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# set working directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# add and install requirements
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# add app
COPY . /usr/src/app

# run server
CMD gunicorn -b 0.0.0.0:5000 manage:app
