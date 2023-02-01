# Use an official Python runtime as a parent image
FROM python:3.6.7

# Set the working directory to /qlik-py-tools
WORKDIR /qlik-py-tools

# Copy the current directory contents into the container at /qlik-py-tools
COPY . /qlik-py-tools

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

# Upgrade pip and setuptools
RUN python -m pip install --upgrade setuptools pip

# Install required packages
RUN pip install --no-cache-dir grpcio
RUN pip install --no-cache-dir grpcio-tools
RUN pip install --no-cache-dir numpy
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir cython
RUN pip install --no-cache-dir pystan==2.17
RUN pip install --no-cache-dir fbprophet
RUN pip install --no-cache-dir -U scikit-learn
RUN pip install --no-cache-dir hdbscan
RUN pip install --no-cache-dir -U skater

# Copy modified file for skater
COPY ./feature_importance.py /usr/local/lib/python3.6/site-packages/skater-1.1.2-py3.6.egg/skater/core/global_interpretation/

# Make port 80 available to the world outside this container
EXPOSE 80

# Set the working directory to /qlik-py-tools/core
WORKDIR /qlik-py-tools/core

# Run __main__.py when the container launches
CMD ["python", "__main__.py"]