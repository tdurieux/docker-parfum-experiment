# CI test image for unit/lint/type tests
FROM 855461928731.dkr.ecr.us-west-1.amazonaws.com/maze-runner:v2-cli as expo-maze-runner
RUN apk add --no-cache ruby-dev build-base libffi-dev curl-dev curl
COPY /test/expo /app/test/expo
WORKDIR /app/test/expo
