FROM ubuntu:14.04
MAINTAINER tony.bussieres@ticksmith.com
RUN apt-get update
RUN apt-get upgrade -y

RUN apt-get -y --no-install-recommends install python-pip python-dev git && rm -rf /var/lib/apt/lists/*;
RUN mkdir /opt/rhodecode
RUN mkdir /var/repo
RUN echo "http://samba.org/~jelmer/dulwich/dulwich-0.8.7.tar.gz" > /tmp/req.txt
RUN pip install --no-cache-dir -r /tmp/req.txt rhodecode==1.7.2
RUN cd /opt/rhodecode && paster make-config RhodeCode production.ini
RUN echo "y" > /tmp/setup.txt

RUN sed -i 's/host = 127.0.0.1/host = 0.0.0.0/' /opt/rhodecode/production.ini
RUN cd /opt/rhodecode && paster setup-rhodecode production.ini --user=admin --email=admin@example.org --repos=/var/repo --password=admin1234  < /tmp/setup.txt
RUN rm /tmp/setup.txt /tmp/req.txt
RUN apt-get install --no-install-recommends -y mercurial && rm -rf /var/lib/apt/lists/*;
CMD cd /opt/rhodecode && paster serve production.ini
