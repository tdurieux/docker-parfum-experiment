FROM ubuntu:16.04

MAINTAINER Mohit Rathore mrmohitrathoremr@gmail.com

ENV REPOSITORY https://github.com/jellAIfish/fromscratchtoml.git
ENV BRANCH docker

RUN apt-get update && apt-get install --no-install-recommends -y python-pip python3-pip git && rm -rf /var/lib/apt/lists/*;

# Upgrade pip
RUN pip install --no-cache-dir --upgrade pip

RUN git clone $REPOSITORY
RUN cd /fromscratchtoml \
&& git checkout $BRANCH \
&& pip install --no-cache-dir -r requirements.txt \
&& pip install --no-cache-dir jupyter \
&& python setup.py install

# Fix ipython kernel version
RUN ipython kernel install

# Add running permission to startup script
RUN chmod +x /fromscratchtoml/docker/start_jupyter_notebook.sh

# Define the starting command for this container and expose its running port
CMD sh -c '/fromscratchtoml/docker/start_jupyter_notebook.sh 7777'
EXPOSE 7777
