FROM node:18

# Pre-requisite distro deps, and build env setup
RUN apt-get --yes update && apt-get --yes install findutils bash vim build-essential curl python3-venv python3-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*;

WORKDIR /src

# Install Cloud Custodian
RUN python3 -m venv custodian
RUN . custodian/bin/activate && pip install --no-cache-dir c7n && pip install --no-cache-dir c7n-org
RUN . custodian/bin/activate && pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir c7n_gcp

# SET CUSTODIAN envirnomet variables
ENV C8R_CUSTODIAN="/src/custodian/bin/custodian"
ENV C8R_CUSTODIAN_ORG="/src/custodian/bin/c7n-org"
ENV PATH="$PATH:/src/custodian/bin"

# Create app directory
WORKDIR /src/c8r-cli

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;
# If you are building your code for production
# RUN npm ci --only=production

# Bundle app source
COPY . .

RUN npm run build
RUN npm link
