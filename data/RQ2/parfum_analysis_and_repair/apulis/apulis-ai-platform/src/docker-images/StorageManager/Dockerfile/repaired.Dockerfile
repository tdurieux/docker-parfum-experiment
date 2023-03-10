FROM python:3.7

RUN pip3 install --no-cache-dir requests==2.22.0 pyyaml==5.2

ADD StorageManager /DLWorkspace/src/StorageManager

COPY run.sh /
RUN chmod +x /run.sh

CMD /run.sh
