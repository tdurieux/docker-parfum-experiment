FROM java:8

RUN apt-get update && apt-get install --no-install-recommends -y gradle && rm -rf /var/lib/apt/lists/*;

WORKDIR /project

ADD src /project/src
ADD src /project/build.gradle
ADD src /project/settings.gradle

EXPOSE 8080
ENTRYPOINT ["gradle", "bootrun"]