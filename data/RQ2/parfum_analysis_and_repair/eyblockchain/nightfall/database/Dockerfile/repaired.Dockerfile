FROM node:14.15

WORKDIR /app

# Install mongodb
RUN wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | apt-key add -
RUN echo "deb http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.2 main" | tee /etc/apt/sources.list.d/mongodb-org-4.2.list
RUN apt-get update && apt-get install --no-install-recommends -y mongodb-org-shell=4.2.10 && rm -rf /var/lib/apt/lists/*;

COPY ./package.json ./package-lock.json ./
RUN npm ci


EXPOSE 80
