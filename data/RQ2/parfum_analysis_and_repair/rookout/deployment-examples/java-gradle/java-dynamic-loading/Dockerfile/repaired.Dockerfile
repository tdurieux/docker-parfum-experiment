FROM openjdk:8-slim
ADD gradlew gradlew
ADD build.gradle build.gradle
ADD gradle gradle
ADD settings.gradle settings.gradle
RUN ./gradlew build
RUN apt update  -y && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y procps && rm -rf /var/lib/apt/lists/*;
ADD . .
RUN ./gradlew jar
