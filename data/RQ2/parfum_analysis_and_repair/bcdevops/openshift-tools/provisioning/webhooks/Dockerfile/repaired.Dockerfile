FROM node

# Install
WORKDIR /app/
COPY ./package.json .
COPY ./package-lock.json .
RUN npm install && npm cache clean --force;
ADD . .

EXPOSE 8080
CMD npm run start
