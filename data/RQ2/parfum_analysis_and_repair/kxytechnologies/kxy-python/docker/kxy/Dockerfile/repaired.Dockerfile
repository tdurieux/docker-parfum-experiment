FROM continuumio/anaconda3

RUN apt-get update
RUN apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends swig -y && rm -rf /var/lib/apt/lists/*;

RUN /opt/conda/bin/conda install gxx_linux-64 gcc_linux-64
RUN /opt/conda/bin/conda install jupyter -y --quiet
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir pyarrow==7.0.0
RUN pip install --no-cache-dir fastparquet==0.8.0
RUN pip install --no-cache-dir emcee==3.1.1 scikit-optimize==0.9.0 pyDOE==0.3.8
RUN pip install --no-cache-dir auto-sklearn==0.14.6

# Install other ML open source librairies
RUN pip install --no-cache-dir xgboost==1.5.2
RUN pip install --no-cache-dir lightgbm==3.3.2
RUN pip install --no-cache-dir tensorflow==2.8.0
RUN pip install --no-cache-dir tensorflow_probability==0.16.0
RUN pip install --no-cache-dir botocore==1.24.27
RUN pip install --no-cache-dir boto3==1.21.27
RUN pip install --no-cache-dir tqdm==4.62.3

# Install kxy
RUN pip install --no-cache-dir kxy==1.4.10

# Copy examples into the Notebooks folder
RUN git clone https://github.com/kxytechnologies/kxy-python.git /opt/kxy-python
RUN mkdir /opt/notebooks
RUN cp -R /opt/kxy-python/docs/latest/applications/case_studies/* /opt/notebooks/
RUN cp -R /opt/kxy-python/docs/latest/applications/illustrations/* /opt/notebooks/