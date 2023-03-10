ARG REFNAME=local
FROM metasfresh/metas-mvn-common:$REFNAME as common
FROM metasfresh/metas-mvn-backend:$REFNAME as backend

FROM maven:3.8.4-jdk-8 as junit

RUN apt-get update && apt-get install --no-install-recommends -y locales npm && rm -rf /var/lib/apt/lists/* && localedef -i de_DE -c -f UTF-8 -A /usr/share/locale/locale.alias de_DE.UTF-8
RUN npm install -g @testmo/testmo-cli && npm cache clean --force;
ENV LANG=de_DE.UTF-8 LANGUAGE=de_DE.UTF-8 LC_MESSAGES=de_DE.UTF-8
ENV TZ=Europe/Berlin

WORKDIR /java

COPY --from=backend /root/.m2 /root/.m2/
COPY --from=common /commons commons
COPY --from=backend /backend backend

RUN cd /java/commons && mvn -o surefire:test -Dmaven.test.failure.ignore=true 2>&1 | tee /java/junit.log
RUN cd /java/backend && mvn -o surefire:test -Dmaven.test.failure.ignore=true 2>&1 | tee -a /java/junit.log

VOLUME /reports

RUN apt-get update && apt-get install --no-install-recommends -y mmv && rm -rf /var/lib/apt/lists/*

SHELL ["/bin/bash", "-c"]
CMD shopt -s globstar && find **/target/surefire-reports/*.xml -printf "%h\n" | uniq | sed 's/\/target\/surefire-reports//' | sed 's/^/\/reports\//' | xargs mkdir -p && mcp ';target/surefire-reports/*.xml' '/reports/#1#2.xml'
