FROM node:6.10.0

# Set up environment
RUN mkdir -p /home/node/app
WORKDIR /home/node/app
ENV NODE_ENV=production

# Clone Project
COPY ./ ./

# Compile Application
RUN yarn install && yarn cache clean;
RUN yarn build

EXPOSE 3000
CMD yarn start