FROM ubuntu:16.04

RUN apt-get update && apt-get -y install \
	python3 \
	python3-dev \
	python3-setuptools \
	python3-pip \
	build-essential \
	libssl-dev \
	libffi-dev \
	python3-numpy \
	python3-scipy \
	python3-matplotlib \
	python3-pandas 

RUN pip3 install -U pip jupyter

# install all dependencies for OpenGrid
ADD requirements.txt /usr/local/opengrid/requirements.txt
RUN pip3 install -r /usr/local/opengrid/requirements.txt

# special treatment for charts required for python3
COPY charts-0.4.6-python3.tar.gz /usr/local/opengrid/charts-0.4.6-python3.tar.gz
RUN pip3 install -U /usr/local/opengrid/charts-0.4.6-python3.tar.gz

# create volumes: one for the source code and work dir, one for the data
VOLUME /usr/local/opengrid
VOLUME /data

# add anonymous data files for electricity, gas and water
ADD data/electricity*.pickle /data/
ADD data/gas*.pickle /data/
ADD data/water*.pickle /data/

# add information for uploading a distribution to pypi.  No passwords!
ADD .pypirc /root/.pypirc

ENV PYTHONPATH=/usr/local/opengrid:$PYTHONPATH
WORKDIR /usr/local/opengrid

# Add Tini. Tini operates as a process subreaper for jupyter. This prevents
# kernel crashes.
ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root", "--NotebookApp.token=''"]

