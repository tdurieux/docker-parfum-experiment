ARG VERS=16.04
FROM ubuntu:${VERS}
ARG JDK=openjdk-8-jdk
RUN apt-get update
RUN apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y ${JDK} && rm -rf /var/lib/apt/lists/*;
RUN mkdir /root/.rd/
COPY test-rd.conf /root/.rd/rd.conf
COPY rundeck-cli_all.deb /root/rundeck-cli_all.deb
RUN dpkg -i /root/rundeck-cli_all.deb
