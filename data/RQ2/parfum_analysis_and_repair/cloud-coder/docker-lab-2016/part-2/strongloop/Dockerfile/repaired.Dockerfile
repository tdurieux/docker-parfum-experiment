FROM sgdpro/nodeslc

COPY ./app/package.json /home/strongloop/app/package.json
WORKDIR /home/strongloop/app
RUN npm install && npm cache clean --force;

COPY ./app /home/strongloop/app
VOLUME /home/strongloop/app
# ENV NODE_ENV production
ENTRYPOINT ["./start.sh"]
