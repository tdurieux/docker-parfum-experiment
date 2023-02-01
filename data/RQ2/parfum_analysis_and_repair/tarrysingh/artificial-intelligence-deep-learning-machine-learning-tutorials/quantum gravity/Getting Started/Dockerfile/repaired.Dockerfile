FROM andrewosh/binder-base
MAINTAINER Jonah Kanner <jonah.kanner@ligo.org>


USER root
RUN apt-get update
RUN apt-get install --no-install-recommends -y libhdf5-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir h5py
#RUN mkdir /home/main/notebook;
#WORKDIR /home/main/notebook
#RUN wget https://losc.ligo.org/s/events/GW150914/H-H1_LOSC_4_V1-1126259446-32.hdf5 && \
#	wget https://losc.ligo.org/s/events/GW150914/L-L1_LOSC_4_V1-1126259446-32.hdf5 && \
#	wget https://losc.ligo.org/s/events/GW150914/H-H1_LOSC_16_V1-1126259446-32.hdf5 && \
#	wget https://losc.ligo.org/s/events/GW150914/L-L1_LOSC_16_V1-1126259446-32.hdf5 && \
#	wget https://losc.ligo.org/s/events/GW150914/GW150914_4_NR_waveform.txt

# Adopted from Kyle Cranmer <kyle.cranmer@nyu.edu>