FROM ubuntu:14.04
RUN apt-get update && apt-get install --no-install-recommends -y curl maven openjdk-7-jre && rm -rf /var/lib/apt/lists/*;
RUN curl -f -O --location https://github.com/brianfrankcooper/YCSB/releases/download/0.12.0/ycsb-0.12.0.tar.gz
RUN tar xfvz ycsb-0.12.0.tar.gz && rm ycsb-0.12.0.tar.gz
WORKDIR ycsb-0.12.0
ENTRYPOINT ["bin/ycsb.sh"]
