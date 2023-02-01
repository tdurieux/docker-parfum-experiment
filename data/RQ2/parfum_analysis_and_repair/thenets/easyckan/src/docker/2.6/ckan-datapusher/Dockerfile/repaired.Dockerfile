FROM ubuntu:16.04

ENV DATAPUSHER_HOME /usr/lib/ckan/datapusher

#Install the required packages
RUN apt-get -qq update
RUN apt-get -qq --no-install-recommends -y install \
        python-dev \
        python-virtualenv \
        build-essential \
        libxslt1-dev \
        libxml2-dev \
        zlib1g-dev \
        git && rm -rf /var/lib/apt/lists/*;

#Create a source directory
RUN mkdir -p $DATAPUSHER_HOME/src

#Switch to source directory
WORKDIR $DATAPUSHER_HOME/src

#Clone the source
RUN git clone -b '0.0.10' https://github.com/ckan/datapusher.git

#Install pip
RUN apt-get install --no-install-recommends -y python-pip && \
        apt-get autoremove -y && \
        pip install --no-cache-dir -U pip && rm -rf /var/lib/apt/lists/*;

#Install the dependencies
WORKDIR datapusher
RUN pip install --no-cache-dir -r requirements.txt && \
        pip install --no-cache-dir -e .
EXPOSE 8800

#Run the DataPusher
CMD [ "python", "datapusher/main.py", "deployment/datapusher_settings.py"]