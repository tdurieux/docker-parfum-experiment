# base image
FROM python:3.7.2-slim

# install netcat
RUN apt-get update && \
    apt-get -y --no-install-recommends install netcat && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# set working directory
WORKDIR /usr/src/app

# add and install requirements
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# add entrypoint-prod.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint-prod.sh
RUN chmod +x /usr/src/app/entrypoint-prod.sh

# add app
COPY . /usr/src/app

# run server
CMD gunicorn -b 0.0.0.0:5000 manage:app
