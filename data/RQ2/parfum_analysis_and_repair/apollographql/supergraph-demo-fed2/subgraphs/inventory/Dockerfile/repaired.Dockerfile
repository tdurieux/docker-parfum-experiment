# Use a separate layer for the build for better caching
FROM gradle:7.4.2-jdk11 AS TEMP_BUILD_IMAGE

WORKDIR /usr/src/app

#COPY app/build.gradle app/settings.gradle .

# Only download dependencies
# Eat the expected build failure since no source code has been copied yet
#RUN gradle clean build --no-daemon --parallel > /dev/null 2>&1 || true

# Copy all files
COPY app .

# Do the actual build
RUN gradle clean build --no-daemon --parallel


# Create a new layer with the build output to run the app