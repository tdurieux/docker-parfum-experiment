FROM iyegoroff/ubuntu-node-android-git:3

RUN mkdir /package
COPY . /package
WORKDIR /package/examples/CustomNativeFilter

RUN npm i -g yarn@1.22.4 && npm cache clean --force;
RUN yarn
RUN npm run generate:android:bundle
RUN rm -rf node_modules/.bin && rm -rf ../../node_modules/.bin
RUN cd android && ./gradlew assembleRelease
