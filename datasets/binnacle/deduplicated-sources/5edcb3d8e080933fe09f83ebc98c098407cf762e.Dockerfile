FROM python:2.7.11

ENV ELASTICKUBE_PATH    /opt/elastickube
ENV PYTHONPATH          /opt/elastickube
ENV KUBE_API_TOKEN_PATH /var/run/secrets/kubernetes.io/serviceaccount/token

WORKDIR ${ELASTICKUBE_PATH}

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927 && \
    echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list

RUN apt-get update -y && \
    apt-get install -y --force-yes mongodb-org-shell libxmlsec1-dev && \
    pip install --no-compile tornado motor PyJWT pycurl "cairosvg>=1.0,<2.0" futures passlib python-saml  && \
    apt-get clean && \
    apt-get autoremove -y

ADD data ${ELASTICKUBE_PATH}/data
ADD api  ${ELASTICKUBE_PATH}/api

CMD ${ELASTICKUBE_PATH}/api/entrypoint.sh
