FROM amazonlinux:latest

WORKDIR /app
USER root
RUN yum update -y
RUN yum -y install wget make gcc openssl-devel bzip2-devel git && rm -rf /var/cache/yum
RUN amazon-linux-extras install python3.8
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.8 /usr/bin/python
RUN python -m pip install --upgrade pip
RUN python -m pip install nltk==3.6.6
RUN python -m pip install transformers==4.5.0
RUN python -m pip install sentencepiece
RUN python -m pip install loguru
RUN python -m pip install nlp==0.2.0
RUN python -m pip install torch
RUN python -m pip install git+https://github.com/sfahad1414/question_generation.git
RUN python -m nltk.downloader punkt
RUN python -m pip install protobuf
RUN python -m pip install elastic-apm
RUN python -m pip install fastapi>=0.68.1
RUN python -m pip install uvicorn>=0.12.3
RUN python -m pip install websockets==10.1
RUN python -m pip install aiohttp==3.8.0
RUN python -m pip install numpy==1.22.0
RUN python -m pip install ujson==5.1.0

COPY augmentation app/augmentation
EXPOSE 8000
CMD ["uvicorn", "augmentation.question_generator.server:app","--host","0.0.0.0"]