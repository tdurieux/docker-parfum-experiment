FROM node:12-alpine
MAINTAINER Ryan Petschek <petschekr@gmail.com>

# Deis wants bash
RUN apk update && apk add --no-cache bash
RUN apk add --no-cache git

# Bundle app source
WORKDIR /usr/src/registration
COPY . /usr/src/registration
RUN npm install && npm cache clean --force;
RUN npm run build

# Set Timezone to EST
RUN apk add --no-cache tzdata
ENV TZ="/usr/share/zoneinfo/America/New_York"
ENV NODE_ENV="production"

# Deis wants EXPOSE and CMD
EXPOSE 3000
CMD ["npm", "start"]
