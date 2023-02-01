FROM ubuntu:latest
MAINTAINER techops@tendrilinc.com

RUN apt-get update && apt-get install --no-install-recommends -q -y python python-pip stress && rm -rf /var/lib/apt/lists/*;
RUN mkdir -p /app
COPY stress.py /app/stress.py

ADD run-stress.sh /app/run-stress.sh
RUN chmod a+x /app/run-stress.sh
CMD /app/run-stress.sh
