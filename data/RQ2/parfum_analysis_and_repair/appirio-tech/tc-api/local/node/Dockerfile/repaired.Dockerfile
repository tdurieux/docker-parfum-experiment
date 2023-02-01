FROM node:0.10

COPY jdk-8u51-linux-x64.gz /opt

RUN cd /opt && \
    tar -xvf jdk-8u51-linux-x64.gz && \
    cd /usr/bin && \
    ln -s /opt/jdk1.8.0_51/bin/java java && \
    ln -s /opt/jdk1.8.0_51/bin/javac javac

ENV JAVA_HOME=/opt/jdk1.8.0_51

RUN npm install -g java && npm cache clean --force;

RUN apt-get install --no-install-recommends -y net-tools psmisc && rm -rf /var/lib/apt/lists/*;
