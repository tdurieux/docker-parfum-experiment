FROM node:6.2.2

COPY package.json /app/
WORKDIR /app
RUN npm install && npm cache clean --force;
COPY index.js /app/

ENV PORT 80
EXPOSE 80
CMD ["node", "/app/index.js"]
