FROM ubuntu:16.04

RUN apt-get update -y
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y openjdk-8-jdk && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y wget && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y unzip && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /home/brusta

RUN wget https://download.pytorch.org/libtorch/cpu/libtorch-shared-with-deps-1.5.0%2Bcpu.zip -O /home/brusta/libtorch.zip
RUN unzip /home/brusta/libtorch.zip -d /home/brusta
RUN rm /home/brusta/libtorch.zip

ADD src /home/brusta/src

WORKDIR /home/brusta/src/build
RUN cmake -DCMAKE_PREFIX_PATH=../libtorch ..
RUN make
RUN mv libModel.* ../../

WORKDIR /home/brusta
