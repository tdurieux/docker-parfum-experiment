FROM ubuntu:14.04
MAINTAINER Matthias Kadenbach <matthias.kadenbach@gmail.com>

RUN apt-get update && apt-get install --no-install-recommends -y python python-pip git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pyftpdlib

ADD ./ftp.py /ftp.py
RUN chmod +x /ftp.py

ENV FTP_ROOT /www
VOLUME ["/www"]

EXPOSE 21

CMD ["./ftp.py"]
