# This Dockerfile is not the one used for official Docker image of TheHive but the result image should be identical
# Official image are generated by sbt (with the command sbt docker:publishLocal)
# This Dockerfile is largely inspired by https://github.com/ilyaglow/dockerfiles/blob/master/thehive/Dockerfile

FROM openjdk:8 as build-env

LABEL MAINTAINER="TheHive Project <support@thehive-project.org>"

ARG THEHIVE_VERSION=develop

RUN apt update && \
  apt install --no-install-recommends -y apt-transport-https && \
  curl -f -sL https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash - && \
  export NVM_DIR="${HOME}/.nvm" && \
  . "$NVM_DIR/nvm.sh" && \
  nvm install --lts && \
  apt-get install --no-install-recommends -y git && \
  npm install -g grunt-cli \
                 bower && \
  git -c advice.detachedHead=false \
      clone \
      --branch=$THEHIVE_VERSION \
      --depth=1 \
      https://github.com/TheHive-Project/TheHive.git && \
  echo '{"allow_root": true}' > /root/.bowerrc && \
  cd TheHive && \
  ./sbt clean stage && \
  mv /TheHive/target/universal/stage /opt/thehive && \
  mv /TheHive/package/docker/entrypoint /opt/thehive/entrypoint && \
  mkdir /var/log/thehive && \
  apt-get purge -y git && \
  rm -rf /TheHive \
         /root/* \
         /root/.nvm \
         /root/.m2 \
         /root/.ivy2 \
         /root/.sbt \
         /var/lib/apt/lists/* && npm cache clean --force;

FROM openjdk:8
COPY --from=build-env /opt/thehive /opt/thehive
COPY --from=build-env /var/log/thehive /var/log/thehive

RUN apt update && \
  apt upgrade -y && \
  apt autoclean -y -q && \
  apt autoremove -y -q && \
  rm -rf /var/lib/apt/lists/* && \
  ( type groupadd 1>/dev/null 2>&1 && \
    groupadd -g 1000 thehive || \
    addgroup -g 1000 -S thehive ) && \
  ( type useradd 1>/dev/null 2>&1 && \
    useradd --system --uid 1000 --gid 1000 thehive || \
    adduser -S -u 1000 -G thehive thehive ) && \
  mkdir /etc/thehive && \
  cp /opt/thehive/conf/logback.xml /etc/thehive/logback.xml && \
  chown -R root:root /opt/thehive && \
  touch /var/log/thehive/application.log && \
  chown -R thehive:thehive /var/log/thehive /etc/thehive && \
  chmod +x /opt/thehive/entrypoint

USER thehive

EXPOSE 9000

WORKDIR /opt/thehive

ENTRYPOINT ["/opt/thehive/entrypoint"]
