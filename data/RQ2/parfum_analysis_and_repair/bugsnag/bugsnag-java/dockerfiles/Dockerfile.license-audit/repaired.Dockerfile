FROM openjdk:8-jdk-slim

RUN apt-get update && apt-get install --no-install-recommends -y ruby-full curl && rm -rf /var/lib/apt/lists/*;

RUN gem install license_finder -v 6.13

WORKDIR /scan
COPY gradle gradle
COPY bugsnag bugsnag
COPY bugsnag-spring bugsnag-spring
COPY build.gradle common.gradle gradle.properties gradlew gradlew.bat LICENSE release.gradle settings.gradle ./

RUN ./gradlew

RUN curl -f https://raw.githubusercontent.com/bugsnag/license-audit/master/config/decision_files/global.yml -o decisions.yml

CMD license_finder --enabled-package-managers=gradle --decisions-file=decisions.yml
