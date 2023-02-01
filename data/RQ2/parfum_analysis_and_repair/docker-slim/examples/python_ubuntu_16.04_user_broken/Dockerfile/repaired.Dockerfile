FROM ubuntu:16.04

RUN apt-get update && \
		apt-get -y --no-install-recommends install python-software-properties python g++ make && \
		apt-get -y --no-install-recommends install python-dev && \
		apt-get -y --no-install-recommends install python-pip && \
		mkdir -p /opt/my/service && rm -rf /var/lib/apt/lists/*;

COPY service /opt/my/service

WORKDIR /opt/my/service

RUN pip install --no-cache-dir -r requirements.txt

RUN adduser --disabled-password --gecos '' appuser\  
  && chown -R appuser:appuser /opt/my/service

USER appuser
EXPOSE 1300
ENTRYPOINT ["python","/opt/my/service/server.py"]
