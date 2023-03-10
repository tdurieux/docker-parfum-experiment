# Use OpenJDK 8
FROM openjdk:8-jdk

ENV URL "https:\/\/localhost:8080\/"
ENV TAGS "@cwe-319-auth"
ENV TAGS_SKIP "~@skip"

# Set a sensible server directory.
WORKDIR /home/bdd-security

# Add the directory
ADD . .

# run gradle
RUN ./gradlew buildIt

# Execute gradle tests