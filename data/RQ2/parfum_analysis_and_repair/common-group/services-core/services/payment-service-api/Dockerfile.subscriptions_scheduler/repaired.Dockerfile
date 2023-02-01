FROM node:10.15-jessie
RUN apt-get install --no-install-recommends -y libssl-dev && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/app
COPY . .
RUN npm install && npm cache clean --force;
CMD ./scripts/subscription_scheduler.js
