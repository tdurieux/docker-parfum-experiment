FROM python:3.5-jessie
ENV PYTHONUNBUFFERED 1
ENV WORKDIR=/workdir
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}
COPY ./requirements.txt ${WORKDIR}
RUN /bin/bash -c "pip install -r requirements.txt"