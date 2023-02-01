FROM sebvaucher/sgx-base:sgx_2.5

# Add SGX SDK libs to source. It does what 'source /opt/intel/sgxsdk/environment' does
ENV SGX_SDK /opt/intel/sgxsdk
ENV PATH=$SGX_SDK/bin:$SGX_SDK/bin/x64:$PATH \
    PKG_CONFIG_PATH=$SGX_SDK/pkgconfig:$PKG_CONFIG_PATH \
    LD_LIBRARY_PATH=$SGX_SDK/sdk_libs:./libs:$LD_LIBRARY_PATH

# Install nodejs dependencies
RUN apt-get update -q -q && \
    apt-get install --no-install-recommends curl libssl1.0-dev --yes && rm -rf /var/lib/apt/lists/*;

# Install nodejs v10
RUN curl -f -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;
RUN npm install npm --global && npm cache clean --force;

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

RUN npm install && npm cache clean --force;

# Bundle app source
COPY . .

CMD [ "npm", "start" ]
