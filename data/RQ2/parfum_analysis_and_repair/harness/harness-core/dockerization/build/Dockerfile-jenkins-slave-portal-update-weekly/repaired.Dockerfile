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

#ARG STEP=RUN