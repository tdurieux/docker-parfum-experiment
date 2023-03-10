FROM node:alpine
ENV NODE_ENV=production
RUN mkdir -p /app
WORKDIR /app
COPY . /app
EXPOSE 8080
RUN npm install --prod && npm cache clean --force;
CMD ["npm", "start"]
