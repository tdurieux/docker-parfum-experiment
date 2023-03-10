FROM ubuntu:20.04
MAINTAINER Aneesh Dogra "https://github.com/lionaneesh"

RUN dpkg --add-architecture i386
RUN apt-get update && apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y socat && rm -rf /var/lib/apt/lists/*;

RUN mkdir /challenges
RUN adduser noob

COPY boiler /challenges/
COPY flag /challenges/
RUN chmod +r /challenges/flag
WORKDIR /challenges/
EXPOSE 31337

#USER noob
#RUN chmod -r /tmp
CMD socat TCP-LISTEN:31337,reuseaddr,fork EXEC:"./boiler"
