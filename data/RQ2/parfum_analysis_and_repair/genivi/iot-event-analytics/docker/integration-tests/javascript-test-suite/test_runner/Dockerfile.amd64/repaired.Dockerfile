FROM node:12.22 as base_stage

ARG HTTP_PROXY
ARG HTTPS_PROXY

ENV HTTP_PROXY=${HTTP_PROXY}
ENV HTTPS_PROXY=${HTTPS_PROXY}


# > > > > > > > > > > > > > > > > > > > > > STAGE 1:
FROM base_stage as pre-build_stage
# Create build directory
RUN mkdir -p /build
WORKDIR /build

# use project root level dependencies
COPY package.json yarn.lock .npmignore ./

# copy & remove what we don't need
COPY /src ./src
RUN rm -rf /build/src/sdk

RUN npm config set strict-ssl false -g
RUN npm config set maxsockets 5 -g

# Audit all packages for security vulnerabilities - exit early
RUN yarn audit --level critical; yarn cache clean; \
    yarncode=$?; \
    if [ "$yarncode" -lt 16 ]; then \
        exit 0; \
    else \
        exit $yarncode; \
    fi


# > > > > > > > > > > > > > > > > > > > > > STAGE 2:
FROM pre-build_stage as build_stage
# install all dependicies
RUN yarn && yarn cache clean;

# Create and install latest SDK - platform
# npm pack results in an output that ensure latest platform is installed
RUN yarn add file:$(npm pack) && yarn cache clean;


# > > > > > > > > > > > > > > > > > > > > > STAGE 3:
FROM build_stage as tidy-up_stage

RUN rm -rf *tgz

# Shrink node_modules
RUN curl -sf https://gobinaries.com/tj/node-prune | sh

# Prune node-modules
RUN node-prune


# > > > > > > > > > > > > > > > > > > > > > STAGE 4:
FROM mhart/alpine-node:slim-12.22 as runtime_stage
# TODO can add in non-root setup here when needed

# Create & set app directory
RUN mkdir -p /app
WORKDIR /app

# Copy in pre-built node modules from base stage
COPY --from=tidy-up_stage /build .

ARG INTEGRATION_TESTS=/test/integration-tests

RUN mkdir -p test/javascript
# Copy in test script to run
COPY ${INTEGRATION_TESTS}/sdk-test-suites/javascript/test_runner.js test/javascript

RUN mkdir -p config/tests/javascript/runner/
COPY ${INTEGRATION_TESTS}/config/tests/javascript/runner/ config/tests/javascript/runner/

WORKDIR /app/test/javascript
CMD ["node", "test_runner.js"]
