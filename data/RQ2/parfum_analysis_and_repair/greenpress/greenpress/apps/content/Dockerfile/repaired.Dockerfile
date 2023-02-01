FROM node:13.3.0
RUN mkdir /app
WORKDIR /app
COPY . .
ENV NODE_ENV=production
RUN npm install && npm cache clean --force;
ENV PORT=9001
EXPOSE $PORT
CMD npm start