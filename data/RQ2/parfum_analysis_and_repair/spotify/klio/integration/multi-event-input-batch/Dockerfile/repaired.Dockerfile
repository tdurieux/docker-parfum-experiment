FROM dataflow.gcr.io/v1beta3/python38-fnapi:2.35.0

WORKDIR /usr/src/app
RUN mkdir -p /usr/src/config && rm -rf /usr/src/config

ENV PYTHONPATH=/usr/src/app

RUN pip install --no-cache-dir --upgrade pip setuptools

COPY core core
COPY lib lib
COPY exec exec
RUN pip install --no-cache-dir ./core
RUN pip install --no-cache-dir ./lib
RUN pip install --no-cache-dir ./exec

COPY job-requirements.txt job-requirements.txt
RUN pip install --no-cache-dir -r job-requirements.txt

COPY __init__.py \
     run.py \
     MANIFEST.in \
     setup.py \
     batch_track_ids_1.txt \
     batch_track_ids_2.txt \
     /usr/src/app/

RUN pip install --no-cache-dir .
