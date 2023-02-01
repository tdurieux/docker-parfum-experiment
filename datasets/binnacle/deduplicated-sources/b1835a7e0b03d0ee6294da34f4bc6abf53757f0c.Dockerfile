FROM dockerfile/ubuntu
MAINTAINER binux <roy@binux.me>

# install python
RUN apt-get update && \
        apt-get install -y python python-dev python-distribute python-pip && \
        apt-get install -y libcurl4-openssl-dev libxml2-dev libxslt1-dev python-lxml

# install requirements
ADD requirements.txt /opt/pyspider/requirements.txt
RUN pip install --allow-all-external -r /opt/pyspider/requirements.txt

# add all repo
ADD ./ /opt/pyspider

# run test
WORKDIR /opt/pyspider
RUN IGNORE_MYSQL=1 IGNORE_RABBITMQ=1 IGNORE_MONGODB=1 ./runtest.py

VOLUME ["/opt/pyspider"]

ENTRYPOINT ["python", "run.py"]

EXPOSE 5000 23333 24444
