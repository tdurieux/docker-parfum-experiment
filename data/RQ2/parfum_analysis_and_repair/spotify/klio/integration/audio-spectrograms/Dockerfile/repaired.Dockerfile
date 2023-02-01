FROM dataflow.gcr.io/v1beta3/python38-fnapi:2.35.0

WORKDIR /usr/src/app
RUN mkdir -p /usr/src/config && rm -rf /usr/src/config

ENV PYTHONPATH=/usr/src/app

RUN apt-get update && apt-get install --no-install-recommends -y libsndfile1 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir --upgrade pip setuptools

COPY core core
COPY lib lib
COPY exec exec
COPY audio audio
RUN pip install --no-cache-dir ./core
RUN pip install --no-cache-dir ./lib
RUN pip install --no-cache-dir ./exec
RUN pip install --no-cache-dir ./audio

COPY job-requirements.txt job-requirements.txt
RUN pip install --no-cache-dir -r job-requirements.txt

COPY __init__.py \
     run.py \
     transforms.py \
     MANIFEST.in \
     setup.py \
     batch_track_ids.txt \
     /usr/src/app/

RUN pip install --no-cache-dir .
