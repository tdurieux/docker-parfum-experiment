FROM ubuntu:latest
RUN mkdir -p /opt/openems-backend
WORKDIR /opt/openems-backend
COPY build/openems-backend.jar ./
COPY config.d ./config.d
COPY openems-backend.sh ./
RUN apt-get update
RUN apt-get install -y --no-install-recommends software-properties-common curl && rm -rf /var/lib/apt/lists/*;
RUN curl -f -sL https://repos.influxdata.com/influxdb.key | apt-key add -
RUN add-apt-repository -y ppa:openjdk-r/ppa
RUN apt-get update
RUN apt-get install --no-install-recommends -y openjdk-11-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-11-jre && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y influxdb && rm -rf /var/lib/apt/lists/*;
RUN update-alternatives --config java
RUN update-alternatives --config javac
RUN chmod 777 ./openems-backend.sh
USER root
EXPOSE 8075-8080
ENTRYPOINT ["./openems-backend.sh"]
