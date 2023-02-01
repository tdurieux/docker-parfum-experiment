FROM ubuntu:16.04
MAINTAINER completeresidue <hyoungseok.k@gmail.com>

RUN echo "deb http://dl.bintray.com/sbt/debian /" | tee -a /etc/apt/sources.list.d/sbt.list
RUN apt-get update -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y --allow-unauthenticated sbt && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/hyoungseok/brusta.git /home/brusta

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-latest.zip -O /home/brusta/launcher/libtorch.zip
RUN unzip /home/brusta/launcher/libtorch.zip -d /home/brusta/launcher
RUN rm /home/brusta/launcher/libtorch.zip

RUN wget https://github.com/intel/mkl-dnn/releases/download/v0.18/mklml_lnx_2019.0.3.20190220.tgz -O /home/brusta/launcher/mklml.tgz
RUN tar zxvf /home/brusta/launcher/mklml.tgz -C /home/brusta/launcher && rm /home/brusta/launcher/mklml.tgz
RUN mv /home/brusta/launcher/mklml_lnx_2019.0.3.20190220/lib/* /home/brusta/launcher/libtorch/lib/
RUN rm -rf /home/brusta/launcher/mklml*

WORKDIR /home/brusta/burner
RUN sbt update

WORKDIR /home/brusta/lever
RUN sbt update
CMD sbt run
