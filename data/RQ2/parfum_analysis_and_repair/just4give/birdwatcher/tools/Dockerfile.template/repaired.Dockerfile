#FROM balenalib/%%BALENA_MACHINE_NAME%%-debian:buster-run
FROM balenalib/%%BALENA_MACHINE_NAME%%-node:build



# Expose websocket port
EXPOSE 3000

# Switch to working directory for our app
WORKDIR /usr/src/app

# Copies the package.json first for better cache on later pushes
COPY ./app/package.json /usr/src/app/

# Install dependencies
RUN JOBS=MAX npm install --production && rm -rf /tmp/* && npm cache clean --force;

# Copy all the source code in.
COPY ./app/ /usr/src/app/

# Launch our binary on container startup.
#CMD ["npm", "start"]

# Start app
CMD ["npm", "start"]