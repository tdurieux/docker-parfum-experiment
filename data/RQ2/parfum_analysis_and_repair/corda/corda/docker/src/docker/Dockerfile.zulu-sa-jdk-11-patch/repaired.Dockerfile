# Build and publish an Azul Zulu patched JDK 11 to the R3 Azure docker registry as follows:

# colljos@ci-agent-101l:~$ cd /home/colljos/azul/case17645
# $docker build . -f Dockerfile.zulu-sa-jdk-11-patch --no-cache -t azul/zulu-sa-jdk:11.0.3_7_LTS
# $docker tag azul/zulu-sa-jdk:11.0.3_7_LTS corda.azurecr.io/jdk/azul/zulu-sa-jdk:11.0.3_7_LTS
# $docker login -u corda corda.azurecr.io
# docker push corda.azurecr.io/jdk/azul/zulu-sa-jdk:11.0.3_7_LTS

# Remember to set the DOCKER env variables accordingly to access the R3 Azure docker registry:
# export DOCKER_URL=https://corda.azurecr.io
# export DOCKER_USERNAME=<username>
# export DOCKER_PASSWORD=<password>

RUN addgroup corda && adduser --ingroup corda --disabled-password -gecos "" --shell /bin/bash corda

COPY zulu11.31.16-sa-jdk11.0.3-linux_x64.tar /opt

RUN tar xvf /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64.tar -C /opt && ln -s /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64 /opt/jdk && rm /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64.tar

RUN rm /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64.tar && \
    chown -R corda /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64 && \
    chgrp -R corda /opt/zulu11.31.16-sa-jdk11.0.3-linux_x64

# Set environment
ENV JAVA_HOME /opt/jdk
ENV PATH ${PATH}:${JAVA_HOME}/bin

CMD ["java", "-version"]