FROM node:16.13.0-slim

# Update apt-dependencies
RUN apt-get update -y

# Dependencies to deploy gh-pages
RUN apt-get -y update && apt-get -y --no-install-recommends install curl bash git openssh-client && rm -rf /var/lib/apt/lists/*;

# Dependencies to run cypress
RUN apt-get install --no-install-recommends -y xvfb libgtk2.0-0 libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 && rm -rf /var/lib/apt/lists/*;

ENV CI true
COPY package*.json ./
RUN npm install --ignore-scripts && npm cache clean --force;

COPY . .
EXPOSE 6006
CMD ["npm", "start"]

