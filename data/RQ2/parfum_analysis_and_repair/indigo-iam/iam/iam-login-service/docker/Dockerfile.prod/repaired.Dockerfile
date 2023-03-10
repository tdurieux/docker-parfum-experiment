FROM openjdk:8

RUN mkdir /indigo-iam
WORKDIR /indigo-iam
COPY iam-login-service.war /indigo-iam/

CMD java -XX:MaxRAMFraction=1 -XX:+UnlockExperimentalVMOptions -XX:+UseCGroupMemoryLimitForHeap ${IAM_JAVA_OPTS} -jar iam-login-service.war 

# Embed TINI since compose v3 syntax do not support the init 
# option to run docker --init
#
ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]