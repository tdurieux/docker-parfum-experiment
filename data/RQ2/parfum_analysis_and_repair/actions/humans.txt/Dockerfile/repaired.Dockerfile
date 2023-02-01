FROM node:12

WORKDIR /opt/humans.txt

COPY . /opt/humans.txt

RUN npm i --production && npm cache clean --force;

ENV FORCE_COLOR=3

ENTRYPOINT ["bash", "/opt/humans.txt/run.sh"]
