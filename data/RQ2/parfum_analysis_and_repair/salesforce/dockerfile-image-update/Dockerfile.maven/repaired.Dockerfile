ARG JDK_VERSION
FROM maven:3.8-openjdk-${JDK_VERSION}-slim AS build

COPY . .

RUN mvn --version
RUN cd /dockerfile-image-update && mvn --quiet --batch-mode install && \
    cd /dockerfile-image-update-itest && mvn --quiet --batch-mode install