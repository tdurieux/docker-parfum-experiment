# base image
FROM python:3.8-buster
ENV PYTHONUNBUFFERED 1

# set working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

RUN pip3 install --no-cache-dir --upgrade pip

# add requirements
COPY ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip3 install --no-cache-dir -r requirements.txt

# add app
COPY . /usr/src/app
