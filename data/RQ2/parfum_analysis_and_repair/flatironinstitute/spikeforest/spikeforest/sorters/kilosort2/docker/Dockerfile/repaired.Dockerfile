FROM spikeinterface/kilosort2-base:0.1.0

RUN pip install --no-cache-dir simplejson requests click

RUN pip install --no-cache-dir h5py

# spikeinterface/spikesorters
RUN pip install --no-cache-dir spikesorters==0.4.4

ENV HITHER_IN_CONTAINER=1

LABEL version="0.1.1"