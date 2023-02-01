FROM node:0.10.40
RUN mkdir -p /usr/src/app && rm -rf /usr/src/app
WORKDIR /usr/src/app
COPY ./NodeJS-Sample-App/EmployeeDB/ ./
RUN npm install && npm cache clean --force;
CMD ["node", "app.js"]

