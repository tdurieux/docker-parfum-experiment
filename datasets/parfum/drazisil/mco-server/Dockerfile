FROM docker.elastic.co/beats/elastic-agent-complete:8.3.2

WORKDIR /home/node/app

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl https://get.volta.sh | bash

RUN ~/.volta/bin/volta install node@18

COPY package*.json ./

RUN ~/.volta/bin/volta run npm ci
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

EXPOSE 80
EXPOSE 6660
EXPOSE 8228
EXPOSE 8226
EXPOSE 7003
EXPOSE 8227
EXPOSE 43200
EXPOSE 43300
EXPOSE 43400
EXPOSE 53303

CMD [ "make", "docker-init" ]
