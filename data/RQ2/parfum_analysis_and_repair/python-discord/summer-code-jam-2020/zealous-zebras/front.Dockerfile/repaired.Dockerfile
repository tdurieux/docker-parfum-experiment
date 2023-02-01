FROM node:alpine
WORKDIR /app
COPY . .
WORKDIR /app/timescape/frontend
RUN npm install -l --silent && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]