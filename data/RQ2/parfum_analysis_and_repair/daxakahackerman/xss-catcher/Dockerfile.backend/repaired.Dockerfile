FROM python:3.8

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
RUN apt-get clean && apt-get autoremove --purge && rm -rf /var/lib/apt/lists/*

COPY ./server /var/www/html/server
WORKDIR /var/www/html/server
RUN python3 -m pip install -r /var/www/html/server/requirements.txt
RUN chmod +x *.sh

EXPOSE 8080
