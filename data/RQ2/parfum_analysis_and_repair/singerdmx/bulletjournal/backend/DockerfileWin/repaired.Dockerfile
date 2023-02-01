# syntax=docker/dockerfile:experimental
FROM gradle:jdk8 AS build
WORKDIR /workspace/app

COPY . /workspace/app

RUN  target=/root/.gradle gradle clean build -x test
RUN mkdir -p build/dependency && (cd build/dependency; jar -xf ../libs/*.jar)

FROM openjdk:8-jdk-alpine
RUN apk add --no-cache fontconfig ttf-dejavu
VOLUME /tmp
ARG DEPENDENCY=/workspace/app/build/dependency
COPY --from=build ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY --from=build ${DEPENDENCY}/META-INF /app/META-INF
COPY --from=build ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.bulletjournal.BulletjournalApplication"]