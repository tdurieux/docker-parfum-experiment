FROM amazonlinux:latest

SHELL ["/bin/bash", "-c"]

ENV KG_HOME=/app

WORKDIR ${KG_HOME}
RUN yum update -y
RUN yum -y install wget make gcc openssl-devel bzip2-devel git && rm -rf /var/cache/yum
RUN amazon-linux-extras install python3.8
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.8 /usr/bin/python
RUN python -m pip install --upgrade pip
RUN python -m pip install pyyaml
RUN python -m pip install loguru
RUN python -m pip install smart-config==0.1.3
RUN python -m pip install python-docx
RUN python -m pip install PyMuPDF
RUN python -m pip install sentencepiece
RUN python -m pip install nltk==3.6.6
RUN python -m pip install torch==1.6.0
RUN python -m pip install nlp
RUN python -m pip install transformers==4.5.0
RUN python -m pip install protobuf
RUN python -m pip install git+https://github.com/sfahad1414/question_generation.git
RUN python -m pip install elastic-apm
RUN python -m pip install pymongo==3.12.0
RUN mkdir ssl
RUN mkdir data_generator
RUN chmod 777 -R /tmp
RUN python -m pip install numpy==1.22.0
RUN python -m pip install ujson==5.1.0

COPY augmentation ${KG_HOME}/augmentation
COPY system.yaml ${KG_HOME}/
COPY template ${KG_HOME}/template
COPY custom ${KG_HOME}/custom
COPY email.yaml ${KG_HOME}/

ENV KAIRON_URL default
ENV USER default
ENV TOKEN default

CMD ["sh","-c","python -m augmentation --generate-training-data ${KAIRON_URL} ${USER} ${TOKEN}"]
