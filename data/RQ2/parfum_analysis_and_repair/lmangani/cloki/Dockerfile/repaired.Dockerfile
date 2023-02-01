# Qryn
FROM node:14-slim

# BUILD FORCE
ENV BUILD 703030
ENV PORT 3100

COPY . /app
WORKDIR /app
RUN npm install && npm cache clean --force;

# Expose Ports
EXPOSE 3100

CMD [ "npm", "start" ]
