# We should create an Open Babel implementation of pipeline_utils that handles the basic I/O for
# structure files so that the dependency on RDKit can be removed.
# See https://github.com/InformaticsMatters/pipelines-obabel/issues/1

FROM informaticsmatters/obabel:latest
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

USER root

# Copy the obabel pipeline implementation into the image
COPY src/python /opt/python-obabel
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python-setuptools \
        gzip \
        python-pip && \
    pip install --no-cache-dir -e /opt/python-obabel && rm -rf /var/lib/apt/lists/*;
# And the project pip requirements
COPY requirements-obabel.txt /root/
RUN pip install --no-cache-dir -r /root/requirements-obabel.txt

# The CMD is simply to run 'execute' in the WORKDIR.
# The user would normally mount a volume with their own execute
# script in it and then set the WORKDIR to the directory it's in.
# In its absence we just run the built-in 'execute',
# which is expected to echo some descriptive/helpful text.
#
# The default 'execute' relies on an ENV to name the pipeline it's in,
# which can be defined with the docker 'pipeline' build argument.
ARG pipeline=informaticsmatters/pipelines-obabel:latest
ENV PIPELINE=$pipeline
WORKDIR /home/obabel
COPY execute ./
RUN chown obabel:0 ./execute && \
    chmod +x ./execute
CMD ["./execute"]

USER obabel
