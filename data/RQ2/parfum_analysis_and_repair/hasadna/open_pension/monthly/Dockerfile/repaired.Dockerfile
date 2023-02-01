FROM node:16.9.0-bullseye-slim

LABEL maintainer="http://www.hasadna.org.il/"

RUN apt-get update && apt-get install --no-install-recommends -y netcat && rm -rf /var/lib/apt/lists/*;

ENV APP_DIR /home/app

WORKDIR $APP_DIR

COPY package*.json ./
RUN npm i && npm cache clean --force;

COPY . $APP_DIR

# Running the entry point.
RUN chmod +x /home/app/entrypoint.sh
CMD [ "/home/app/entrypoint.sh" ]
