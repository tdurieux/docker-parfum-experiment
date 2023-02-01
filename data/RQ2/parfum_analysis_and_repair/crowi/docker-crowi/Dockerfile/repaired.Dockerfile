FROM node:6

ENV CROWI_VERSION v1.6.3
ENV NODE_ENV production

RUN curl -f -SL -o /usr/local/bin/wait-for-it.sh https://raw.githubusercontent.com/vishnubob/wait-for-it/master/wait-for-it.sh \
	&& chmod +x /usr/local/bin/wait-for-it.sh

RUN mkdir /usr/src/app \
	&& curl -f -SL https://github.com/crowi/crowi/archive/${CROWI_VERSION}.tar.gz \
	| tar -xz -C /usr/src/app --strip-components 1 && rm -rf /usr/src/app

WORKDIR /usr/src/app

RUN npm install --unsafe-perm && npm cache clean --force;

COPY docker-entrypoint.sh /entrypoint.sh

VOLUME /data
ENTRYPOINT ["/entrypoint.sh"]
CMD ["npm", "start"]
