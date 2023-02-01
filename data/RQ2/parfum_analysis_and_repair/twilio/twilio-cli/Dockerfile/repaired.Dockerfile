FROM node:14.18.1
RUN apt-get update && apt-get install --no-install-recommends -y libsecret-1-dev && rm -rf /var/lib/apt/lists/*;

RUN mkdir /twilio
WORKDIR /twilio

COPY . .
RUN npm link
