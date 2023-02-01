FROM ubuntu:14.04

RUN apt-get update && \
		apt-get -y --no-install-recommends install python-software-properties python build-essential && \
		apt-get -y --no-install-recommends install python-dev && \
		apt-get -y --no-install-recommends install python-pip && \
		mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 9000
#ENTRYPOINT ["python","/opt/my/service/server.py"]


