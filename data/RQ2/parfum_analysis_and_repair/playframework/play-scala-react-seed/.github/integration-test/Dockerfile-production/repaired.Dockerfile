FROM hseeberger/scala-sbt:8u312_1.6.2_2.13.8
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
RUN sbt stage

ENTRYPOINT ["/bin/bash", "--login", "-c", "./target/universal/stage/bin/play-scala-react-seed -Dplay.http.secret.key=ad31779d4ee49d5ad5162bf1429c32e2e9933f3b"]