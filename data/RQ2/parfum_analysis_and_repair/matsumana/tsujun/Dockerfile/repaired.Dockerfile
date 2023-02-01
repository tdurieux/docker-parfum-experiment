# for build
FROM openjdk:8 AS build-env

# install Node.js
RUN curl -f -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install --no-install-recommends -y nodejs && rm -rf /var/lib/apt/lists/*;

# install yarn
RUN npm install -g yarn && npm cache clean --force;

# compile app
RUN mkdir /root/tsujun
COPY . /root/tsujun
WORKDIR /root/tsujun
RUN rm -rf src/main/resources/static/node_modules
RUN ./yarnInstall.sh
RUN ./gradlew clean build



# for runtime
FROM openjdk:8

COPY --from=build-env /root/tsujun/build/libs/tsujun-*.jar /root/tsujun.jar

EXPOSE 8080

CMD ["java", "-jar", "/root/tsujun.jar"]
