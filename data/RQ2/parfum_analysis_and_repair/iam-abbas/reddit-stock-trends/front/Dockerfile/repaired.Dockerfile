# Set base image (host OS)
FROM node:lts-alpine
WORKDIR /code
# Install dependencies
RUN npm install && npm cache clean --force;
RUN npm install -g @vue/cli && npm cache clean --force;

# Command to run on container start
CMD [ "sh", "-c", "npm run serve" ]
