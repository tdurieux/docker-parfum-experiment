FROM spikeinterface/tridesclous-base:1.6.1

RUN pip install --no-cache-dir simplejson requests click

# spikeinterface/spikesorters
RUN pip install --no-cache-dir spikesorters==0.4.4

LABEL version="1.6.1"