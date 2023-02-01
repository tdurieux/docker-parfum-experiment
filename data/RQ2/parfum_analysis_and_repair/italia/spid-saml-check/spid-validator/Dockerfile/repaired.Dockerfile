FROM ubuntu:latest
MAINTAINER Michele D'Amico, michele.damico@agid.gov.it

# Create user to run validator (not root for security reason!)
RUN useradd --user-group --create-home --shell /bin/false validator

# Set the working directory
WORKDIR /spid-validator

# Copy the current directory to /spid-validator
ADD . /spid-validator

# Update and install utilities
RUN apt-get update && \
    apt-get install --no-install-recommends -y curl && \
    apt-get install --no-install-recommends -y vim && \
    apt-get install --no-install-recommends -y net-tools && \
    apt-get install --no-install-recommends -y unzip libxml2-utils && \
    apt-get install --no-install-recommends -y apache2 && rm -rf /var/lib/apt/lists/*;

# Node 6
RUN apt-get install --no-install-recommends -y nodejs && \
    apt-get install --no-install-recommends -y npm && \
    apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Build validator
RUN cd /spid-validator && \
    cd client && npm install --suppress-warnings && cd .. && \
    cd server && npm install --suppress-warnings && cd .. && \
    npm run build && npm cache clean --force;

# Ports exposed
EXPOSE 8080

RUN chown -R validator:validator /spid-validator/*

USER validator

ENTRYPOINT ["npm", "run", "start-prod"]
