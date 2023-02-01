FROM codefresh/buildpacks:all-5

COPY package.json /cf-errors/package.json
WORKDIR /cf-errors
RUN npm install && npm cache clean --force;
COPY . /cf-errors
