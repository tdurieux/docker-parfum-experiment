FROM biopython/biopython-sql:latest
MAINTAINER Tiago Antao <tra@popgen.net>

ENV DEBIAN_FRONTEND noninteractive

WORKDIR /
#IPython notebook
RUN apt-get install --no-install-recommends --force-yes -y python3-zmq python3-jinja2 && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir pyzmq --upgrade
RUN pip3 install --no-cache-dir jupyter --upgrade
RUN mkdir scratch
WORKDIR scratch
ADD startup.sh /usr/bin/startup
RUN chmod +x /usr/bin/startup
ENV JUPYTER_USER=jupyteruser \
    JUPYTER_UID=1555 \
    JUPYTER_GID=1555 \
    JUPYTER_HOME=/scratch
#CMD jupyter notebook --no-browser --ip=* --port=9803
EXPOSE 9803 9803
CMD /usr/bin/startup
