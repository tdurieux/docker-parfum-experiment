FROM agileek/ionic-framework:3.19.1

RUN apt-get update -y
RUN apt-get install -y bzip2 build-essential
RUN apt-get install -y pkg-config libcairo2-dev
RUN apt-get install -y libjpeg-dev

# android build tools version
RUN ["/opt/tools/android-accept-licenses.sh", "android update sdk --all --no-ui --filter build-tools-26.0.2,android-27"]

# create app directory
RUN mkdir /app
WORKDIR /app

# echo
RUN npm install -g npm@6.4.1
RUN npm cache verify

# install ionic
RUN npm install -g ionic@3.20.0

# install cordova
RUN npm install -g cordova@8.1.2

# Install app dependencies, using wildcard if package-lock exists
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json

# install dependencies
RUN npm install --no-optional

# copy config.xml, ionic configs and resources to allow plugin installation
COPY config.xml /app/config.xml
COPY ionic.config.json /app/ionic.config.json
COPY ./resources /app/resources

RUN mkdir www

# run ionic android build
RUN ionic info

# Bundle app source
COPY ./hooks /app/hooks

# add android platform
RUN ionic cordova platforms add android

# Bundle app source
COPY . /app

# set version code
ARG BUILD_NR
RUN sed -i -e "s/android-versionCode=\"1\"/android-versionCode=\"$BUILD_NR\"/g" config.xml

# build apk
RUN ionic cordova build android --prod --release --no-interactive

# copy release-apk
RUN cp /app/platforms/android/app/build/outputs/apk/release/app-release-unsigned.apk android-release-unsigned.apk

RUN cp android-release-unsigned.apk android-debug.apk

# sign using debug key
RUN jarsigner -verbose -keystore ./build/android/debug.keystore -storepass android -keypass android android-debug.apk androiddebugkey
