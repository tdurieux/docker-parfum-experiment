FROM ubuntu:16.04 as pysheep_base

### get pip git etc

RUN apt-get update
RUN apt-get -y --no-install-recommends install git && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install cmake && rm -rf /var/lib/apt/lists/*;
RUN apt-get -y --no-install-recommends install wget && rm -rf /var/lib/apt/lists/*;

####### install python packages for the frontend
RUN apt-get install --no-install-recommends -y python3 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir flask
RUN pip3 install --no-cache-dir wtforms
RUN pip3 install --no-cache-dir pytest
RUN pip3 install --no-cache-dir sqlalchemy
RUN pip3 install --no-cache-dir python-nvd3
RUN pip3 install --no-cache-dir requests

####### python packages for jupyter
RUN pip3 install --no-cache-dir jupyter
RUN pip3 install --no-cache-dir matplotlib==3.0.3
RUN pip3 install --no-cache-dir pandas

#### run the flask app

ADD . frontend

#
WORKDIR frontend/webapp
####
EXPOSE 5000
ENV FLASK_APP app.py
ENV SHEEP_HOME /frontend
####
CMD ["python3","app.py"]
