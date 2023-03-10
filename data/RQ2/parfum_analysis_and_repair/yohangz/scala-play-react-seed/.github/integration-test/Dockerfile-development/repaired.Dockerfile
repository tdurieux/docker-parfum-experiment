FROM hseeberger/scala-sbt:8u312_1.6.2_2.13.8
EXPOSE 3000
EXPOSE 9000

RUN ln -s /usr/local/openjdk-8/bin/java /usr/bin/java
SHELL ["/bin/bash", "--login", "-c"]

COPY . /opt

WORKDIR /opt
RUN curl -f -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

WORKDIR /opt/ui
RUN nvm install
RUN nvm use
RUN npm install && npm cache clean --force;

WORKDIR /opt
RUN sbt compile

ENTRYPOINT ["/bin/bash", "--login", "-c", "sbt run"]