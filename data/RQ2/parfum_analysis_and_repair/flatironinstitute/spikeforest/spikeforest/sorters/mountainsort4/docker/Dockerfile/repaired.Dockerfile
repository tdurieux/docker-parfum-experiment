FROM spikeinterface/mountainsort4-base:1.0.0

RUN pip install --no-cache-dir simplejson requests click

# spikeinterface/spiketoolkit
RUN pip install --no-cache-dir spiketoolkit==0.7.4

LABEL version="1.0.0"