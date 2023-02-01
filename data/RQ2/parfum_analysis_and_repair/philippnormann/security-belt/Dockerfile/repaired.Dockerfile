FROM node:12

ENV SEC_BELT_HOME /home/node/security-belt
ENV NODE_ENV production

WORKDIR $SEC_BELT_HOME

COPY . $SEC_BELT_HOME

RUN chown -R node $SEC_BELT_HOME
RUN npm install && npm cache clean --force;

USER node

ENTRYPOINT ["npm"]
CMD ["start"]
