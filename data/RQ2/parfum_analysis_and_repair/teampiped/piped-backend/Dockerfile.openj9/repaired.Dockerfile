FROM ibm-semeru-runtimes:open-11-jdk AS build

WORKDIR /app/

COPY . /app/

RUN --mount=type=cache,target=/root/.gradle/caches/ \
 ./gradlew shadowJar

FROM ibm-semeru-runtimes:open-11-jre

WORKDIR /app/

COPY --from=build /app/build/libs/piped-1.0-all.jar /app/piped.jar

COPY VERSION .

EXPOSE 8080

CMD java -server -XX:+UnlockExperimentalVMOptions -XX:+OptimizeStringConcat -XX:+UseStringDeduplication -XX:+UseCompressedOops -XX:+UseNUMA -XX:+UseParallelGC -XX:-UseBiasedLocking -Xshareclasses:allowClasspaths -jar /app/piped.jar