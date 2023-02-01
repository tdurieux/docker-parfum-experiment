# registry.erda.cloud/erda/sonar:8.9.6
FROM sonarqube:8.9.6-community

# prevent anonymous user from accessing project data and so on
ENV SONAR_FORCEAUTHENTICATION true

# add htpasswd
RUN echo "http://mirrors.aliyun.com/alpine/v3.12/main/" > /etc/apk/repositories && echo "http://mirrors.aliyun.com/alpine/v3.12/community/" >> /etc/apk/repositories
RUN apk add apache2-utils

# add sha384sum
RUN apk add coreutils

WORKDIR ${SONARQUBE_HOME}

# embed plugins
RUN cd ${SQ_EXTENSIONS_DIR} && \
    wget https://terminus-dice.oss-cn-hangzhou.aliyuncs.com/sonarqube/plugins/sonar-go-plugin-1.6.0.719.jar && \
    wget https://terminus-dice.oss-cn-hangzhou.aliyuncs.com/sonarqube/plugins/sonar-java-plugin-6.5.1.22586.jar && \
    wget https://terminus-dice.oss-cn-hangzhou.aliyuncs.com/sonarqube/plugins/sonar-pmd-plugin-3.2.1.jar

ADD ./entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh