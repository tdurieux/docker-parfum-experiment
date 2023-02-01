# https://hub.docker.com/orgs/seataio
FROM openjdk:8u232-jre-stretch

# set label
LABEL maintainer="Seata <seata.io>"

WORKDIR /$BASE_DIR

# ADD FORM distribution
ADD bin/ /seata-server/bin
ADD lib/ /seata-server/lib
ADD conf/ /seata-server/conf
ADD LICENSE-BIN /seata-server/LICENSE

# set extra environment