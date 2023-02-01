FROM node:12.15.0

RUN mkdir -p /root/app/
WORKDIR /root/app
COPY . .

RUN npm install --unsafe-perm && npm cache clean --force;

CMD ["npm","start","--","--start","--config","/etc/app.conf"]
