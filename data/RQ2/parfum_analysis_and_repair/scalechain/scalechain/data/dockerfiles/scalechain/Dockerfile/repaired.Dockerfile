#
# Scala and sbt Dockerfile
#
# https://github.com/hseeberger/scala-sbt
#

# Pull base image
FROM java:8

ENV SCALA_VERSION 2.11.8
ENV SBT_VERSION 0.13.11

# Install Scala
## Piping curl directly in tar
RUN \
  curl -fsL https://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz | tar xfz - -C /root/ && \
  echo >> /root/.bashrc && \
  echo 'export PATH=~/scala-$SCALA_VERSION/bin:$PATH' >> /root/.bashrc

# Install sbt
RUN \
  curl -f -L -o sbt-$SBT_VERSION.deb https://dl.bintray.com/sbt/debian/sbt-$SBT_VERSION.deb && \
  dpkg -i sbt-$SBT_VERSION.deb && \
  rm sbt-$SBT_VERSION.deb && \
  apt-get update && \
  apt-get install -y --no-install-recommends sbt && \
  sbt sbtVersion && rm -rf /var/lib/apt/lists/*;

# Define working directory
WORKDIR /root

# Download source code of ScaleChain
RUN \
  cd /root && \
  git clone https://github.com/scalechain/scalechain && \
  git checkout proto-new-chain

# Compile ScaleChain
RUN \
  cd /root/scalechain && \
  sbt clean compile 

# Define working directory
WORKDIR /root/scalechain
ENTRYPOINT ["/root/scalechain/run.sh"]

