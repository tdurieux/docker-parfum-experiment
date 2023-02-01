FROM python:2.7.11

ENV ELASTICKUBE_PATH    /opt/elastickube
ENV PYTHONPATH          /opt/elastickube

WORKDIR ${ELASTICKUBE_PATH}

ADD data   ${ELASTICKUBE_PATH}/data
ADD charts ${ELASTICKUBE_PATH}/charts

RUN pip install --no-compile tornado motor GitPython pyyaml

CMD ${ELASTICKUBE_PATH}/charts/entrypoint.sh
