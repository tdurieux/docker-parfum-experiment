FROM openjdk:8-jdk-slim

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full curl && rm -rf /var/lib/apt/lists/*;

RUN gem install license_finder -v 6.13

WORKDIR /scan
COPY gradle gradle
COPY src src
COPY build.gradle gradle.properties gradlew gradlew.bat LICENSE settings.gradle ./

RUN ./gradlew

RUN curl -f https://raw.githubusercontent.com/bugsnag/license-audit/master/config/decision_files/global.yml -o decisions.yml
RUN curl -f https://raw.githubusercontent.com/bugsnag/license-audit/master/config/decision_files/bugsnag-android-gradle-plugin.yml >> decisions.yml

CMD license_finder --enabled-package-managers=gradle --decisions-file=decisions.yml
