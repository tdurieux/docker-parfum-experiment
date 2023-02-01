FROM centos:7

RUN yum update -y
RUN yum install -y sudo curl wget unzip && rm -rf /var/cache/yum
RUN yum install -y yum-utils –y && rm -rf /var/cache/yum
RUN yum install -y python36 python36-libs python36-devel python36-pip && rm -rf /var/cache/yum

RUN mkdir /app
WORKDIR /app

COPY grpc-mate-python.tar /app
RUN tar xvf /app/grpc-mate-python.tar -C /app && rm /app/grpc-mate-python.tar
RUN pip3 install --no-cache-dir -r /app/requirements.txt
ENV PYTHONPATH=.

EXPOSE 8080

CMD ["python3","server/server.py"]
#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
#ENTRYPOINT ["/entrypoint.sh"]