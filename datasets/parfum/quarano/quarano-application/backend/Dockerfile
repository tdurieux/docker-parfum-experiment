FROM openjdk:11-jre

# Add User
RUN adduser --system --uid 1001 user
USER user
WORKDIR /home/user

# TODO: We should have a prod profile that is active in prod (after MVP)
ENV JAVA_OPTS="-Dspring.profiles.active=default,prod"
ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]

# This statement is the last one because it changes frequently
COPY backend/target/coronareport_backend-0.0.1-SNAPSHOT.jar app.jar
