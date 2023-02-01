FROM python:3.7
RUN pip install --no-cache-dir kopf
ADD ./requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt
ADD . /src
ENV PEERING operator.l7mp.io
ENV KOPF_NAMESPACE --namespace=default
ENV KOPF_ARGS ""
CMD kopf run --peering=$PEERING $KOPF_NAMESPACE $KOPF_ARGS /src/l7mp.py
