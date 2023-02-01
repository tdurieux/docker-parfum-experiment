FROM statsd/statsd:v0.9.0
RUN npm install socket.io@2.3.0 && npm cache clean --force;
COPY config.js /usr/src/app/config.js
COPY statsd-socket.io.js /usr/src/app/node_modules/statsd-socket.io/lib/statsd-socket.io.js
COPY statsd-socket.io.js /usr/src/app/statsd-socket.io.js
EXPOSE 8127
