FROM eclipsecbi/ubuntu-gtk3-metacity:18.10-gtk3.24

USER 0
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install gnupg curl apt-transport-https && rm -rf /var/lib/apt/lists/*;
RUN sh -c 'curl https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -'
RUN sh -c 'curl https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list'
RUN apt-get -y update && \
    apt-get -y --no-install-recommends install dart openjdk-8-jdk maven && rm -rf /var/lib/apt/lists/*;

USER 10001

RUN echo $PATH

RUN dart --version
RUN java -version
RUN mvn -version
RUN echo $PATH