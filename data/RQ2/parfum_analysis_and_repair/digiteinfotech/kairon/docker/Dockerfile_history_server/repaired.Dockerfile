FROM amazonlinux:latest

WORKDIR /app
RUN yum update -y
RUN yum -y install wget make gcc openssl-devel bzip2-devel && rm -rf /var/cache/yum
RUN amazon-linux-extras install python3.8
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3.8 /usr/bin/python

RUN python -m pip install --upgrade pip
RUN python -m pip install pyyaml
RUN python -m pip install mongoengine==0.23.1
RUN python -m pip install rasa[full]==2.8.15
RUN python -m pip install cython
RUN python -m pip install pandas
RUN python -m pip install pyjwt
RUN python -m pip install passlib[bcrypt]
RUN python -m pip install python-multipart
RUN python -m pip install validators
RUN python -m pip install secure
RUN python -m pip install password-strength
RUN python -m pip install loguru
RUN python -m pip install smart-config==0.1.3
RUN python -m pip install elastic-apm
RUN python -m pip install uvicorn>=0.12.3
RUN python -m pip install fastapi>=0.68.1
RUN python -m pip install websockets==10.1
RUN python -m pip install aiohttp==3.8.0
RUN python -m pip install transformers==4.5.0
RUN python -m pip install fastapi_sso
RUN python -m pip install blinker
RUN python -m pip install json2html
RUN mkdir ssl
RUN python -m pip install numpy==1.22.0
RUN python -m pip install ujson==5.1.0
RUN python -m pip install jira

COPY kairon /app/kairon
COPY metadata /app/metadata
COPY email.yaml /app/email.yaml
COPY system.yaml /app/system.yaml
EXPOSE 8083

CMD ["uvicorn", "kairon.history.main:app","--host","0.0.0.0","--port","8083"]
