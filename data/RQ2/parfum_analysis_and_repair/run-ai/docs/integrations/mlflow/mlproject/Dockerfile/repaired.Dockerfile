FROM continuumio/miniconda3

RUN pip install --no-cache-dir mlflow >=1.0
RUN pip install --no-cache-dir azure-storage-blob==12.3.0
RUN pip install --no-cache-dir numpy >=1.14.3
RUN pip install --no-cache-dir scipy
RUN pip install --no-cache-dir pandas >=0.22.0
RUN pip install --no-cache-dir scikit-learn >=0.19.1
RUN pip install --no-cache-dir cloudpickle
