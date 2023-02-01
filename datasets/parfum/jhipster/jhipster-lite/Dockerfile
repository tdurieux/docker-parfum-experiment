FROM openjdk:17-slim
COPY . /code/jhipster-app/
RUN \
    # configure the "jhipster" user
    groupadd jhipster && \
    useradd jhipster -s /bin/bash -m -g jhipster -G sudo && \
    echo 'jhipster:jhipster' |chpasswd && \
    cd /code/jhipster-app/ && \
    rm -Rf target node_modules && \
    chmod +x mvnw && \
    ./mvnw package -DskipTests && \
    mv /code/jhipster-app/target/*.jar /code/ && \
    rm -Rf /code/jhipster-app/ /root/.m2 /root/.cache /tmp/* /var/tmp/*

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JAVA_OPTS="" \
    SPRING_PROFILES_ACTIVE=cloud
USER jhipster
CMD java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /code/*.jar
EXPOSE 7471
