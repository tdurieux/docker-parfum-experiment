FROM ubuntu:20.04

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install --no-install-recommends -y git cmake g++ curl && rm -rf /var/lib/apt/lists/*;

RUN git clone https://github.com/IEDB/TCRMatch.git
RUN cd /TCRMatch/ && make
RUN cd /TCRMatch/scripts && ./update.sh
