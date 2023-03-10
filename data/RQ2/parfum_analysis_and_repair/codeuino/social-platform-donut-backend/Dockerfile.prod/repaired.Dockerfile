FROM node:14

ENV NODE_ENV="production"

WORKDIR /server

RUN git clone https://github.com/codeuino/social-platform-donut-backend.git

WORKDIR /server/social-platform-donut-backend

RUN npm install && \
    npm install pm2@latest -g && \
    npm cache clean --force --loglevel=error

# Start the server
CMD [ "pm2", "start", "./bin/www", "--time", "--no-daemon" ]