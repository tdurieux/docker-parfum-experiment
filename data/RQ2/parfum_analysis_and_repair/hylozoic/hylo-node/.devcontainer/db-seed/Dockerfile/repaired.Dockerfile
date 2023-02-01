FROM node:buster

RUN apt-get update && apt-get install --no-install-recommends -y postgresql-client && rm -rf /var/lib/apt/lists/*;
COPY ./init-db.sh /root/init-db.sh

WORKDIR /root
CMD ./init-db.sh
