FROM mhart/alpine-node

EXPOSE 2525
ENTRYPOINT ["mb"]
CMD ["start","--mock", "--allowInjection", "--debug"]
ENV MOUNTEBANK_VERSION=2.2.1

RUN apk add --no-cache --update nodejs
RUN npm install -g mountebank@${MOUNTEBANK_VERSION} --production && npm cache clean --force;