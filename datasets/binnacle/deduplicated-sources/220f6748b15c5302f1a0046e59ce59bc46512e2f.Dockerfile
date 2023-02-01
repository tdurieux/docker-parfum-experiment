FROM ubuntu:16.04
MAINTAINER completeresidue <hyoungseok.k@gmail.com>

RUN apt-get update -y
RUN apt-get install -y wget
RUN apt-get install -y unzip
RUN apt-get install -y openjdk-8-jdk

RUN mkdir -p /home/brusta/launcher

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-latest.zip -O /home/brusta/launcher/libtorch.zip
RUN unzip /home/brusta/launcher/libtorch.zip -d /home/brusta/launcher
RUN rm /home/brusta/launcher/libtorch.zip

RUN wget https://github.com/intel/mkl-dnn/releases/download/v0.18/mklml_lnx_2019.0.3.20190220.tgz -O /home/brusta/launcher/mklml.tgz
RUN tar zxvf /home/brusta/launcher/mklml.tgz -C /home/brusta/launcher
RUN mv /home/brusta/launcher/mklml_lnx_2019.0.3.20190220/lib/* /home/brusta/launcher/libtorch/lib/
RUN rm -rf /home/brusta/launcher/mklml*

ADD brusta-server.zip /home/brusta/brusta-server.zip
ADD trace_model.pth /home/brusta/trace_model.pth

RUN unzip /home/brusta/brusta-server.zip -d /home/brusta
RUN rm /home/brusta/brusta-server.zip
RUN mv /home/brusta/burner-0.1.0/flint/* /home/brusta

WORKDIR /home/brusta
CMD ./run-server.sh
