FROM node:alpine

ENV NODE_ENV=production

COPY package.json .
RUN npm install --production && npm cache clean --force;
COPY . .

EXPOSE 80
ENV PORT=80

CMD ["node", "scripts/run-templatetemplate.js"]
