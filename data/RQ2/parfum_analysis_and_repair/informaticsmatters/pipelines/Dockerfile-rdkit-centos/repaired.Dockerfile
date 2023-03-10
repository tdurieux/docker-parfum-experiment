FROM informaticsmatters/rdkit-python-centos:latest
LABEL maintainer="Tim Dudgeon<tdudgeon@informaticsmatters.com>"

USER root

# install required packages
RUN yum -y update && yum -y install zip unzip python-devel python2-pip python-setuptools python2-matplotlib && rm -rf /var/cache/yum

# Copy the pipeline implementation into the image
COPY src/python /opt/python
COPY requirements-rdkit.txt /root/
RUN pip install --no-cache-dir -e /opt/python
# And the pip packages from the project requirements
# NOTE: matplotlib is missing
RUN pip install --no-cache-dir -r /root/requirements-rdkit.txt

# The CMD is simply to run 'execute' in the WORKDIR.
# The user would normally mount a volume with their own execute
# script in it and then set the WORKDIR to the directory it's in.
# In its absence we just run the built-in 'execute',
# which is expected to echo some descriptive/helpful text.
#
# The default 'execute' relies on an ENV to name the pipeline it's in,
# which can be defined with the docker 'pipeline' build argument.
ARG pipeline=informaticsmatters/rdkit_pipelines:latest
ENV PIPELINE=$pipeline
WORKDIR /home/rdkit
COPY execute ./
RUN chmod +x ./execute
CMD ["./execute"]
