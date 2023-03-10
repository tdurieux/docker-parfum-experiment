# Use an official Python runtime as a parent image
FROM python:3.6.8

# Set the working directory to /qlik-py-tools
WORKDIR /qlik-py-tools

# Copy the current directory contents into the container at /qlik-py-tools
COPY . /qlik-py-tools

# Install dependencies
RUN apt-get update && apt-get install -y --no-install-recommends build-essential && rm -rf /var/lib/apt/lists/*;

# Upgrade pip and setuptools
RUN python -m pip install --upgrade setuptools pip

# Install required packages
RUN pip install --no-cache-dir grpcio==1.26.0 grpcio-tools==1.26.0 numpy==1.17.5 scipy==1.4.1 pandas==0.25.3 cython==0.29.14 joblib==0.11 holidays==0.9.11 pyyaml==5.3
RUN pip install --no-cache-dir pystan==2.17
RUN pip install --no-cache-dir fbprophet==0.4.post2
RUN pip install --no-cache-dir scikit-learn==0.21.3
RUN pip install --no-cache-dir hdbscan==0.8.23
RUN pip install --no-cache-dir skater==1.1.2
RUN pip install --no-cache-dir spacy==2.1.4
RUN pip install --no-cache-dir efficient_apriori==1.0.0
RUN pip install --no-cache-dir tensorflow==1.14.0
RUN pip install --no-cache-dir keras==2.2.5
RUN python -m spacy download en

# Copy modified file for skater
COPY ./feature_importance.py /usr/local/lib/python3.6/site-packages/skater-1.1.2-py3.6.egg/skater/core/global_interpretation/

# Make ports 80 and 50055 available to the world outside this container
EXPOSE 80 50055

# Set the working directory to /qlik-py-tools/core
WORKDIR /qlik-py-tools/core

# Run __main__.py when the container launches
CMD ["python", "__main__.py"]