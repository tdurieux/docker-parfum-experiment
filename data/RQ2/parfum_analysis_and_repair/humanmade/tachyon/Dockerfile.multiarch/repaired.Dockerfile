FROM node:14-alpine

# Install build base
RUN apk --update add --no-cache \
	--virtual build-deps fftw-dev gcc g++ make libc6-compat python3
RUN apk --update add --no-cache \
	vips-dev

# Get app
COPY ./ /srv/tachyon/
WORKDIR /srv/tachyon
RUN rm -rf node_modules
RUN npm install aws-sdk && npm cache clean --force;
RUN npm install --production && npm cache clean --force;

# Clean up
RUN apk del build-deps

# Enable env vars
ARG AWS_REGION
ARG AWS_S3_BUCKET
ARG AWS_S3_ENDPOINT
ARG PORT
ARG DEBUG=0

# Start the server
EXPOSE ${PORT:-8080}
CMD (($DEBUG)) && node server.js ${PORT:-8080} --debug || node server.js ${PORT:-8080}
