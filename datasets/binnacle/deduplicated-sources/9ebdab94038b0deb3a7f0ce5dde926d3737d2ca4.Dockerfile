FROM python:3.6.4

# install environment dependencies
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    netcat \
  && apt-get -q clean

# set working directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# add requirements
COPY ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip install -r requirements.txt

# add entrypoint-stage.sh
COPY ./entrypoint-stage.sh /usr/src/app/entrypoint-stage.sh

# add app
COPY . /usr/src/app

# run server
CMD ["./entrypoint.sh"]
