# Start with neurodebian image
FROM neurodebian:trusty
LABEL authors="Christopher Coogan <c.coogan2201@gmail.com>, Adam Li <ali39@jhu.edu>"

# Run apt-get calls
COPY sources /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-get update \
    && apt-get install --no-install-recommends -y fsl-6.0-core && rm -rf /var/lib/apt/lists/*;

# Configure environment
ENV FSLDIR=/usr/lib/fsl/6.0
ENV FSLOUTPUTTYPE=NIFTI_GZ
ENV PATH=$PATH:$FSLDIR
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$FSLDIR

# Run configuration script for normal usage
RUN echo ". /etc/fsl/6.0/fsl.sh" >> /root/.bashrc