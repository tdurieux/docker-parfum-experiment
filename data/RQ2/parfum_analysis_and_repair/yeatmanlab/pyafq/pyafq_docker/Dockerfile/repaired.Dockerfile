###############################################################################
# Dockerfile to build pyAFQ
###############################################################################

# Use python base image
FROM python:3.8

ARG COMMIT

# Install pyAFQ
RUN pip install --no-cache-dir git+https://github.com/yeatmanlab/pyAFQ.git@${COMMIT}
RUN pip install --no-cache-dir fslpy
RUN pip install --no-cache-dir h5py

ENTRYPOINT ["pyAFQ"]
