FROM adoptopenjdk:11-jre-hotspot

ENV SPRING_OUTPUT_ANSI_ENABLED=ALWAYS \
    JHIPSTER_SLEEP=0 \
    JAVA_OPTS=""

RUN curl -f -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    curl -f -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
    apt-get update && \
    apt-get install --no-install-recommends -y nodejs yarn && \
    yarn global add generator-jhipster@7.8.1 && rm -rf /var/lib/apt/lists/*;

CMD echo "The application will start in ${JHIPSTER_SLEEP}s..." && \
    sleep ${JHIPSTER_SLEEP} && \
    java ${JAVA_OPTS} -Djava.security.egd=file:/dev/./urandom -jar /app.war

EXPOSE 8080

ADD *.war /app.war
