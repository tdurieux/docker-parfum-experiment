FROM lambci/lambda:build-nodejs10.x

# working folder
RUN mkdir /build
WORKDIR /build

# install dependencies (highly cacheable)
COPY package.json /build/package.json
RUN npm install --production && npm cache clean --force;

# add source code
COPY index.js /build/index.js

# zip entire context and stream output
RUN zip -r /build/dist.zip . > /dev/null
CMD ["cat", "/build/dist.zip"]
