FROM node:16-alpine

# create directory
RUN mkdir /opt/ricochet-frontend/

RUN apk update
RUN apk add --no-cache git

# copy files for build
COPY ./ /opt/ricochet-frontend

# run build & start website
CMD cd /opt/ricochet-frontend && yarn && yarn start

# Expose port 3000
EXPOSE 3000
