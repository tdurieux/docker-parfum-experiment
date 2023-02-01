# Dockerfile for the Face Detection Service

# Use an official Python runtime as a parent image
FROM tensorflow/tensorflow:1.14.0-gpu-py3

# Set the working directory to /app
WORKDIR /app

# Update Linux package lists
RUN apt-get update

# Install build tools (gcc etc.)
RUN apt-get install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;

# Install ops tools
RUN apt-get install --no-install-recommends -y procps vim && rm -rf /var/lib/apt/lists/*;

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir h5py==2.9.0
#RUN pip install hdf5==1.10.4
RUN pip install --no-cache-dir imageio==2.6.1
RUN pip install --no-cache-dir keras==2.2.4
RUN pip install --no-cache-dir matplotlib==3.1.1
RUN pip install --no-cache-dir numpy==1.16.4
RUN pip install --no-cache-dir pandas==1.0.3
RUN pip install --no-cache-dir scikit-image==0.15.0
RUN pip install --no-cache-dir scikit-learn==0.21.3
RUN pip install --no-cache-dir scipy==1.3.0

# Copy the current directory contents into the container at /app
COPY . /app
RUN pwd

RUN python setup.py install

# compile in a version label so we always can find the source in git
ARG VERSION=unspecified
LABEL instantdl.version=$VERSION

# Make port 80 available to the world outside this container
EXPOSE 80

# Define environment variable
# @TODO: add GPU and cudatoolkit
ENV PYTHONUNBUFFERED TRUE
ENV INSTANT_DL_CONFIG /data/config.json
ENV NUM_WORKER 4

# Run InstantDL code
CMD ["python", "instantdl/main.py", "--config", "/data/config.json"]