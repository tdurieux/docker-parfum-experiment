FROM microservice_focal
MAINTAINER Cerebro <cerebro@ganymede.eu>

#--- Install required Python and Pip. ---
RUN apt-get update && apt-get upgrade -y && apt-get install --no-install-recommends -y python3 python3-dev python3-pip && rm -rf /var/lib/apt/lists/*;

RUN python3 -m pip install --upgrade setuptools
RUN python3 -m pip install --upgrade /opt/microservice

COPY ./src /opt/microservice_python3/src

ENV PYTHONPATH /opt/microservice_python3/src
