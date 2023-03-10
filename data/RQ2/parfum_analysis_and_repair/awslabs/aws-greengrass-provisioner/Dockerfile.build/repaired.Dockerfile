FROM amazoncorretto:11-al2-full

COPY build.gradle /build/
COPY gradlew /build/
COPY gradle/wrapper/ /build/gradle/wrapper
WORKDIR /build/

# Run clean to fetch gradle. We do this before we get the source so we don't pull Gradle each time the source changes.
RUN ./gradlew clean --no-daemon

# Fetch binaries
RUN ./gradlew downloadAll --no-daemon

# Copy the source and do the final build
COPY src /build/src
RUN ./gradlew build --no-daemon