#FROM balenalib/%%BALENA-MACHINE-NAME%%-node:build
FROM balenalib/%%BALENA_MACHINE_NAME%%-node:build

# Install build tools and remove layer cache afterwards
#RUN install_packages git python make gcc g++ libvips-dev
# Install dependencies
RUN apt-get update && \
  apt-get install --no-install-recommends -yq unzip \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

EXPOSE 8080

# Switch to working directory for our app
WORKDIR /usr/src/app

# Copies the package.json first for better cache on later pushes
COPY ./app/package.json /usr/src/app/

# Install dependencies
RUN JOBS=MAX npm install --production && rm -rf /tmp/* && npm cache clean --force;

# Copy all the source code in.
COPY ./app/ /usr/src/app/

# Launch our binary on container startup.
CMD ["npm", "start"]
