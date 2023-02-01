# needs to be in sync with node version in elektra image!
FROM keppel.eu-de-1.cloud.sap/ccloud-dockerhub-mirror/library/node:12-buster

LABEL source_repository="https://github.com/sapcc/elektra"

WORKDIR /tmp/elektra-node
ADD package.json yarn.lock ./
RUN yarn

# docker build -t elektra-jest-tests -f docker/Dockerfile.jest-tests
# docker run -it --rm  -v /workspace/elektra:/app -w /app elektra-jest-tests yarn test