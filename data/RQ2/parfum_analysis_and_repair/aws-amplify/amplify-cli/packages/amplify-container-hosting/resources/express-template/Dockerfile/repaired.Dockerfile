FROM public.ecr.aws/bitnami/node:14-prod-debian-10

WORKDIR /app

COPY package*.json ./
RUN npm install && npm cache clean --force;
COPY . .

EXPOSE 8080

CMD ["node", "index.js"]
