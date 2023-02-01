FROM python:3.8

# install layers of prerequisites that don't change as often
# required for kachery_p2p support
RUN pip install --no-cache-dir simplejson requests click

# for spiketoolkit
RUN pip install --no-cache-dir numpy scipy pandas
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir joblib networkx
RUN pip install --no-cache-dir h5py

# install spikeextractors, spiketoolkit, spikecomparison
RUN pip install --no-cache-dir spikeextractors==0.9.5 spiketoolkit==0.7.4 spikecomparison==0.3.2

# For hither singularity mode, this label needs to be consistent with the version on dockerhub
LABEL version="0.7.4"