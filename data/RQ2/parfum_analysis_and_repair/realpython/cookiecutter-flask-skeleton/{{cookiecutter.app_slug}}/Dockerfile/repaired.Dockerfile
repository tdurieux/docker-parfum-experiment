FROM python:3.8.1-slim

# install netcat
RUN apt-get update \
  && apt-get -y --no-install-recommends install netcat \
  && apt-get clean && rm -rf /var/lib/apt/lists/*;

# set working directory
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app

# add requirements
COPY ./requirements.txt /usr/src/app/requirements.txt

# install requirements
RUN pip install --no-cache-dir -r requirements.txt

# add entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh

# add app
COPY . /usr/src/app

# run server
CMD ["./entrypoint.sh"]
