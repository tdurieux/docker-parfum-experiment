FROM python:3.6.3

# install environment dependencies
RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    netcat \
  && apt-get -q clean && rm -rf /var/lib/apt/lists/*;

# set working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add requirements
ADD ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip install --no-cache-dir -r requirements.txt

# add entrypoint.sh
ADD ./entrypoint-stage.sh /usr/src/app/entrypoint-stage.sh

# add app
ADD . /usr/src/app

# run server
CMD ["./entrypoint-stage.sh"]
