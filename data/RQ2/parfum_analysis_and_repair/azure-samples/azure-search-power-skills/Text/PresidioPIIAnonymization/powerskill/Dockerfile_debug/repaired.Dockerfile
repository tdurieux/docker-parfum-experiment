FROM python:3.8

# [Optional] If your pip requirements rarely change, comment this section to add them to the image.
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

RUN python -m spacy download en_core_web_lg

RUN mkdir -p /usr/src/api && rm -rf /usr/src/api
RUN mkdir -p /usr/src/api/powerskill && rm -rf /usr/src/api/powerskill

WORKDIR /usr/src/api

COPY powerskill /usr/src/api/powerskill/
COPY app.py /usr/src/api/

# https://docs.microsoft.com/en-gb/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
EXPOSE 80 2222
EXPOSE 5000

ADD startup.sh /
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
