FROM node:erbium-buster

USER root
RUN sed -i -e '/jessie-updates/d' /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

RUN groupadd -r task -g 433
RUN useradd -u 431 -r -g task -m -s /sbin/nologin -c "Docker image user" task

USER task
WORKDIR /home/task

COPY package.json /home/task/
RUN npm install && npm cache clean --force;

COPY index.js /home/task/

CMD [ "node", "--harmony", "index.js" ]
