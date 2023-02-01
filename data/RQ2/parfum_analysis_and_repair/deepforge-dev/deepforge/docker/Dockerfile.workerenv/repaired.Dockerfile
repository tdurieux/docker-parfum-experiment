FROM node:12

LABEL maintainer1.name="Brian Broll"\
      maintainer1.email="brian.broll@gmail.com"

LABEL maintainer2.name="Umesh Timalsina"\
      maintainer2.email="umesh.timalsina@vanderbilt.edu"

SHELL ["/bin/bash", "-c"]

ENV MINICONDA Miniconda3-latest-Linux-x86_64.sh

ADD ./src/plugins/GenerateJob/templates/environment.worker.yml /tmp

WORKDIR /tmp

RUN curl -f -O  https://repo.anaconda.com/miniconda/$MINICONDA && bash $MINICONDA -b && rm -f $MINICONDA

ENV PATH /root/miniconda3/bin:$PATH

RUN conda update conda -yq

RUN npm install -g npm && npm cache clean --force;
RUN npm install requirejs@2.3.5 rimraf@^2.4.0 superagent@3.8.3 @babel/runtime@^7.7.2 q@1.5.1 node-fetch@2.6.0 agentkeepalive@3.4.1 aws-sdk@2.624.0 && npm cache clean --force;
RUN pip install --no-cache-dir simplejson
RUN conda env create -n deepforge --file /tmp/environment.worker.yml

ENTRYPOINT /bin/bash
