FROM node:8-alpine
MAINTAINER Max Shapiro "maxshapiro32@ibm.com"
COPY . /worklog
WORKDIR /worklog
RUN npm install && npm cache clean --force;
EXPOSE 3000
CMD ["npm", "start"]