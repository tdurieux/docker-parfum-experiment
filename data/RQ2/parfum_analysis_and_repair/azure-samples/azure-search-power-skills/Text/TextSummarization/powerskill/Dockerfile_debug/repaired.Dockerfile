FROM python:3.8

# [Optional] If your pip requirements rarely change, uncomment this section to add them to the image.
COPY requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

RUN apt-get update && apt-get install --no-install-recommends 'libsm6' \
    'libgl1-mesa-glx' \
    'libxext6' -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/api && rm -rf /usr/src/api
RUN mkdir -p /usr/src/api/powerskill && rm -rf /usr/src/api/powerskill
RUN mkdir -p /usr/src/api/models && rm -rf /usr/src/api/models

WORKDIR /usr/src/api

COPY models /usr/src/api/models/
COPY powerskill /usr/src/api/powerskill/
COPY app.py /usr/src/api/

# https://docs.microsoft.com/en-gb/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
EXPOSE 80 2222
EXPOSE 5000

ADD startup.sh /
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
