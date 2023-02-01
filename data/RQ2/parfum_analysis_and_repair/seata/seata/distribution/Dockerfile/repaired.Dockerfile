# https://hub.docker.com/orgs/seataio
FROM openjdk:8u232-jre-stretch

# set label
LABEL maintainer="Seata <seata.io>"

WORKDIR /$BASE_DIR

# ADD FORM distribution
ADD bin/ /seata-server/bin
ADD target/ /seata-server/target
ADD conf/ /seata-server/conf
ADD LICENSE /seata-server/LICENSE

# set extra environment