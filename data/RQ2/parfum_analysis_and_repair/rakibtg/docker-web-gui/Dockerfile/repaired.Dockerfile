FROM node:alpine
WORKDIR /src
ADD ./backend /src/backend
ADD ./client /src/client
ADD ./app.js /src/app.js
RUN cd /src/backend && npm install --silent && npm cache clean --force;
CMD ["node", "/src/app.js"]
EXPOSE 3230