FROM node:12-alpine

HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 CMD [ "/bin/sh", "-c", "wget -O- http://localhost:8000/healthz | grep ok" ]

RUN mkdir -p /usr/src/app \
 && adduser -s /bin/false -D app \
 && chown app:app /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY auth/package.json auth/package-lock.json /usr/src/app/
COPY lib /usr/src/lib
RUN npm install && npm cache clean --force;
COPY auth /usr/src/app/
CMD ["dev.js"]
