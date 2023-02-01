FROM python:3.7

RUN pip3 install --no-cache-dir --upgrade pip

ENV FLASK_APP app.py
ENV FLASK_CONFIG docker

RUN mkdir -p /usr/labellab/labellab-flask
WORKDIR /usr/labellab/labellab-flask

COPY requirements.txt requirements.txt
COPY docker.txt docker.txt
RUN pip install --no-cache-dir -r docker.txt
COPY ./boot.sh /boot.sh

RUN chmod +x /boot.sh

EXPOSE 5000

ENTRYPOINT [ "/boot.sh" ]