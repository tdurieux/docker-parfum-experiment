FROM ubuntu AS awsIotDeviceSdk

# Get curl
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;

# Get n to install NodeJS
RUN curl -f -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n lts

# Install the source for the AWS IoT Device SDK for Javascript v1
RUN npm install aws-iot-device-sdk && npm cache clean --force;
WORKDIR node_modules/aws-iot-device-sdk

# Install browserify to build the SDK into a browser bundle
RUN npm install -g browserify && npm cache clean --force;

# Unfortunate hack because the first time browserize runs in Docker it fails
# Include cognitoidentity so browserize doesn't include the entire AWS SDK
RUN AWS_SERVICES=cognitoidentity npm run-script browserize; AWS_SERVICES=cognitoidentity npm run-script browserize

# Install uglify-js to reduce the bundle size (from ~1.4 MB -> ~488k)
RUN npm install -g uglify-js && npm cache clean --force;

# Reduce the bundle size
RUN uglifyjs browser/aws-iot-sdk-browser-bundle.js -c -m -o browser/aws-iot-sdk-browser-bundle-min-uglifyjs.js

FROM ubuntu AS builder

# Get curl and OpenJDK
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;

# Get Docker to run additional Docker builds on the host
RUN apt-get -y --no-install-recommends install apt-transport-https ca-certificates curl gnupg2 software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
RUN apt-get -y update
RUN apt-get -y --no-install-recommends install docker-ce-cli && rm -rf /var/lib/apt/lists/*;

# Get n to install NodeJS
RUN curl -f -L https://raw.githubusercontent.com/tj/n/master/bin/n -o n
RUN bash n lts

# Install CDK
RUN npm install -g aws-cdk@1.89.0 && npm cache clean --force;

COPY build.gradle.kts /serverless-ui/jwt-stack/
COPY Dockerfile /serverless-ui/jwt-stack/
COPY gradlew /serverless-ui/jwt-stack/
COPY gradle/wrapper/ /serverless-ui/jwt-stack/gradle/wrapper
WORKDIR /serverless-ui/jwt-stack

# Run the Gradle clean task to cache Gradle early so we don't have to rebuild the cache each time the source changes
RUN ./gradlew clean --no-daemon

# Copy the code for the stack and the Javascript AWS IoT device SDK
COPY src /serverless-ui/jwt-stack/src
COPY --from=awsIotDeviceSdk node_modules/aws-iot-device-sdk/browser/aws-iot-sdk-browser-bundle-min-uglifyjs.js /serverless-ui/jwt-stack/src/main/webapp/aws-iot-sdk-browser-bundle-min.js
COPY cdk.json /serverless-ui/jwt-stack

# Build the GWT code here so we can cache it before we run "cdk deploy"
RUN ./gradlew compileGwt --no-daemon

# Set the working directory to the stack's directory
WORKDIR /serverless-ui/jwt-stack
