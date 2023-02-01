FROM openjdk:8-slim
RUN mkdir /proj
ADD gradlew /proj/gradlew
ADD build.gradle /proj/build.gradle
ADD gradle /proj/gradle
ADD settings.gradle /proj/settings.gradle
RUN /proj/gradlew build
RUN apt update  -y && apt install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
ADD . /proj
WORKDIR /proj
RUN ./gradlew jar

