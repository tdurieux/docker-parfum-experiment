FROM openjdk:11-jdk-slim

# install required packages
RUN apt-get -yq update
RUN apt-get -yqq --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get -yqq --no-install-recommends install curl && rm -rf /var/lib/apt/lists/*;
# kubectl
RUN apt-get install --no-install-recommends -yqq apt-transport-https gnupg2 && rm -rf /var/lib/apt/lists/*;
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get -yq update
RUN apt-get -yqq --no-install-recommends install kubectl && rm -rf /var/lib/apt/lists/*;

# kubeseal
RUN wget -nv https://github.com/bitnami-labs/sealed-secrets/releases/download/v0.15.0/kubeseal-linux-amd64 -O kubeseal --no-check-certificate
RUN install -m 755 kubeseal /usr/local/bin/kubeseal

WORKDIR /tmp

# add app jar
ARG JAR_FILE
ADD ${JAR_FILE} app.jar

# setup environment
ENV SPRING_PROFILES=prod,keycloak
EXPOSE 8080

ENTRYPOINT ["sh","-c","java -Dspring.profiles.active=$SPRING_PROFILES -jar app.jar", "--spring.config.location=/tmp/config/"]
