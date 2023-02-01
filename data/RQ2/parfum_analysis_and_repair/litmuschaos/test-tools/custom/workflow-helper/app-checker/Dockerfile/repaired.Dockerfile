FROM python:3

ARG TARGETPLATFORM

LABEL maintainer="LitmusChaos"

ADD main.py /
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir uuid

CMD [ "python", "./main.py" ]
