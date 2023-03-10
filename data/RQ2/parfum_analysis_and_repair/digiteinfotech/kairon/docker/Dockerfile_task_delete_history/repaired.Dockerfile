FROM amazonlinux:latest

SHELL ["/bin/bash", "-c"]

ENV TASK_HOME=/app

WORKDIR ${TASK_HOME}
RUN yum update -y
RUN yum -y install wget make gcc openssl-devel bzip2-devel && rm -rf /var/cache/yum
RUN amazon-linux-extras install python3.8
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.8 /usr/bin/python
RUN python -m pip install --upgrade pip
RUN python -m pip install pyyaml
RUN python -m pip install rasa[full]==2.8.15
RUN python -m pip install mongoengine==0.23.1
RUN python -m pip install validators
RUN python -m pip install loguru
RUN python -m pip install smart-config==0.1.3
RUN python -m pip install passlib[bcrypt]
RUN python -m pip install password-strength
RUN python -m pip install elastic-apm
RUN python -m pip install pymongo==3.12.0
RUN python -m pip install fastapi>=0.68.1
RUN python -m pip install uvicorn>=0.12.3
RUN python -m pip install nlpaug
RUN python -m pip install torch
RUN python -m pip install regex
RUN python -m pip install nltk==3.6.6
RUN python -m pip install pytest
RUN python -m nltk.downloader wordnet
RUN python -m nltk.downloader averaged_perceptron_tagger
RUN python -m nltk.downloader omw-1.4
RUN python -m pip install websockets==10.1
RUN python -m pip install blinker
RUN python -m pip install aiohttp==3.8.0
RUN python -m pip install transformers==4.5.0
RUN python -m pip install numpy==1.22.0
RUN python -m pip install ujson==5.1.0


RUN mkdir ssl
RUN mkdir testing_data
RUN mkdir models
RUN chmod 777 -R /tmp

COPY kairon ${TASK_HOME}/kairon
COPY system.yaml ${TASK_HOME}/

ENV BOT default
ENV USER default
ENV MONTH default
ENV SENDER_ID default


CMD ["sh","-c","python -m kairon delete-conversation ${BOT} ${USER} ${MONTH} ${SENDER_ID}"]
