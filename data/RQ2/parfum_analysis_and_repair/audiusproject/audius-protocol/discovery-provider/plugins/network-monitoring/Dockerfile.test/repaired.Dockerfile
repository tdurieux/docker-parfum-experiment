# It makes tests much easier
# It's just a Dockerfile that runs a single network monitoring job
# because the main Dockerfile that's used in production wraps everything in a CRON job

FROM node:16

RUN apt-get update && apt-get -y --no-install-recommends install -qq --force-yes cron && rm -rf /var/lib/apt/lists/*;

WORKDIR /network-monitoring

# Install app dependencies from package.json. If modules are not included in the package.json file enter a RUN command. E.g. RUN npm install <module-name>
COPY package.json /network-monitoring/
RUN npm install && npm cache clean --force;

COPY . .

CMD ["npm", "run", "staging"]
