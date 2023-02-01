FROM tensorflow/tensorflow

COPY custom-skills-deployment/requirements.txt /tmp/pip-tmp/
RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
    && rm -rf /tmp/pip-tmp

RUN apt-get update && apt-get install --no-install-recommends 'libsm6' \
    'libgl1-mesa-glx' \
    'libxext6' -y && rm -rf /var/lib/apt/lists/*;

RUN mkdir -p /usr/src/ml && rm -rf /usr/src/ml
RUN mkdir -p /usr/src/ml/extractors && rm -rf /usr/src/ml/extractors
RUN mkdir -p /usr/src/ml/similarity && rm -rf /usr/src/ml/similarity
RUN mkdir -p /usr/src/ml/models && rm -rf /usr/src/ml/models
RUN mkdir -p /usr/src/ml/utils && rm -rf /usr/src/ml/utils
RUN mkdir -p /usr/src/api && rm -rf /usr/src/api
RUN mkdir -p /usr/src/api/common && rm -rf /usr/src/api/common
RUN mkdir -p /usr/src/api/extractor && rm -rf /usr/src/api/extractor
RUN mkdir -p /usr/src/api/models && rm -rf /usr/src/api/models

COPY sshd_config /etc/ssh/

WORKDIR /usr/src/api

COPY ml/extractors /usr/src/ml/extractors
COPY ml/models /usr/src/ml/models
COPY ml/similarity /usr/src/ml/similarity
COPY ml/utils /usr/src/ml/utils
COPY custom-skills-deployment/models /usr/src/api/models/
COPY custom-skills-deployment/extractor/ /usr/src/api/extractor/
COPY custom-skills-deployment/app.py /usr/src/api/

# https://docs.microsoft.com/en-gb/azure/app-service/configure-custom-container?pivots=container-linux#enable-ssh
EXPOSE 80 2222
EXPOSE 5000

ADD startup.sh /
RUN chmod +x /startup.sh

CMD ["/startup.sh"]
