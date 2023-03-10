# This is the template dockerfile for each package.
# If you want to use an custom dockerfile for an package simply put an Dockerfile into the package folder.

# base will be the the image build by the base dockerfile.
FROM base as build

# Here the dependencies will be installed and the local required packages bootstrapped.
# The --slim flag will cause the package json to only include the dependencies, so not all changes to the package json cause docker to reinstall all packages.
COPY --slim ./package.json ./
RUN npm install && npm cache clean --force;
# The normal package.json should be copied after the install into the container
COPY ./package.json ./

# This will only add the command to the dockerfile if the build script exists in the package otherwise its ignored.
RUN --if-exists npm run build
