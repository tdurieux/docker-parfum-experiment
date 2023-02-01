#For updating image weekly. Use jenkins-slave-portal-open-8u242:kubectl_with_gcc as base_jdk

#FROM base_jdk
#COPY settings.xml /root/.m2/settings.xml
#ENV OVERRIDE_LOCAL_M2 /root/.m2/repository

#ARG GITHUB_USERNAME=?
#ARG GITHUB_PASSWORD=?
#ARG JFROG_USERNAME=?
#ARG JFROG_PASSWORD=?
#ARG PLATFORM=jenkins
#ARG STEP=dockerization

#RUN cd /root \
    #&& git clone https://${GITHUB_USERNAME}:${GITHUB_PASSWORD}@github.com/harness/harness-core.git \
    #&& cd harness-core \
    #&& source /etc/profile.d/maven.sh \
    #&& for i in 1 2 3 4 5; do \
          #BUILD_PURPOSE=DEVELOPMENT \
          #mvn -B -T 2C -Dmaven.repo.local=/root/.m2/repository -s /root/.m2/settings.xml \
              #compile test-compile dependency:go-offline \
          #&& break ; done \
    #&& cd tools \
    #&& for i in 1 2 3 4 5; do \
          #mvn -B -T 2C -Dmaven.repo.local=/root/.m2/repository -s /root/.m2/settings.xml \
              #compile test-compile dependency:go-offline \
          #&& break ; done \
    #&& cd .. \
    #&& rm -rf `find . -type d -name target` \
    #&& rm -rf /root/.m2/repository/software/wings

#ARG STEP=RUN