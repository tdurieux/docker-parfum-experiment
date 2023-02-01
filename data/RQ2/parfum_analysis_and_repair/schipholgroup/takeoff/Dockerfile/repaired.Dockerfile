FROM python:3.8-slim

RUN apt-get update && apt-get install -y --no-install-recommends curl gnupg2 && rm -rf /var/lib/apt/lists/*;

## Java
RUN mkdir -p /usr/share/man/man1 && apt-get install --no-install-recommends -y openjdk-11-jre-headless && rm -rf /usr/share/man/man1 && rm -rf /var/lib/apt/lists/*;
ENV JAVA_HOME=/usr/lib/openjdk-11
ENV PATH=$PATH:$JAVA_HOME/bin

## SBT
RUN echo "deb https://repo.scala-sbt.org/scalasbt/debian all main" | tee -a /etc/apt/sources.list.d/sbt.list
RUN curl -f -sL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x2EE0EA64E40A89B84B2DF73499E82A75642AC823" | apt-key add
RUN apt-get update && apt-get install --no-install-recommends -y sbt && rm -rf /var/lib/apt/lists/*;

## Docker
RUN apt-get install --no-install-recommends -y \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
RUN apt-get update && apt-get install --no-install-recommends -y docker-ce && rm -rf /var/lib/apt/lists/*;

## Kubectl
RUN curl -f -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN touch /etc/apt/sources.list.d/kubernetes.list
RUN echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
RUN apt-get update && apt-get install -y --no-install-recommends kubectl=1.19.3-00 && rm -rf /var/lib/apt/lists/*;

RUN apt-get clean && rm -rf /var/lib/apt/lists/*

## Takeoff
COPY setup.py /root
COPY MANIFEST.in /root
COPY README.md /root
COPY scripts /root/scripts
COPY takeoff /root/takeoff

WORKDIR /root

RUN python setup.py install

WORKDIR /src
