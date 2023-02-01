FROM fujin/precise
MAINTAINER fujin
ENV DEBIAN_FRONTEND noninteractive
ENV PYTHONPATH .
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe multiverse' > /etc/apt/sources.list
RUN apt-get update && apt-get install --no-install-recommends -y -q git make python-all python-pip && rm -rf /var/lib/apt/lists/*;
RUN git clone https://github.com/micktwomey/pypicache.git /srv/pypicache
RUN cd /srv/pypicache && make init
CMD cd /srv/pypicache && make runserver
EXPOSE 8080