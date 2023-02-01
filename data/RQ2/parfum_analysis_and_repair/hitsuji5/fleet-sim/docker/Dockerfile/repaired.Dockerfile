FROM python:3.6

USER root
RUN set -x && \
    apt-get update
ENV HOME=/home

#USER root
WORKDIR $HOME
COPY ./requirements.txt /$HOME/
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["python", "src/run.py"]