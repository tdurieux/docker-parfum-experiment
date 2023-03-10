FROM node:178.0-alpine

RUN mkdir -p /usr/src/app && \
	chown -R nobody:nogroup /usr/src/app && rm -rf /usr/src/app

ENV HOME=/usr/src/app
WORKDIR /usr/src/app
USER nobody

ADD --chown=nobody:nogroup ./package* ./
RUN npm ci --fetch-timeout=600000

EXPOSE 3000
ENTRYPOINT ["npm", "run"]
CMD ["start"]

COPY --chown=nobody:nogroup . .
