FROM ubuntu:18.04

MAINTAINER  Fraunhofer IAIS , https://vocol.iais.fraunhofer.de

# Install OpenJDK-11
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install --no-install-recommends -y software-properties-common && \
    apt-get install --no-install-recommends -y openjdk-11-jdk && \
    apt-get clean; rm -rf /var/lib/apt/lists/*;

# Setup JAVA_HOME -- useful for docker commandline
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64/
RUN export JAVA_HOME



# Install Nodejs , git
RUN apt-get update -yq \
    && apt-get install --no-install-recommends curl gnupg git ruby psmisc -yq \
    && curl -f -sL https://deb.nodesource.com/setup_11.x | bash \
    && apt-get install --no-install-recommends nodejs -yq && rm -rf /var/lib/apt/lists/*;

# Build application
RUN mkdir /home/project
WORKDIR /home/project
RUN git clone  https://github.com/vocol/vocol.git \
&&  chmod u+x  .
WORKDIR /home/project/vocol
RUN npm install && npm cache clean --force;

EXPOSE 3000
EXPOSE 3030

ENV PORT=3000
CMD [ "npm", "start","3000","3030"]























