FROM condaforge/miniforge3

RUN pip install --no-cache-dir mlflow >=1.0 \
    && pip install --no-cache-dir azure-storage-blob==12.3.0 \
    && pip install --no-cache-dir numpy==1.21.2 \
    && pip install --no-cache-dir scipy \
    && pip install --no-cache-dir pandas==1.3.3 \
    && pip install --no-cache-dir scikit-learn==0.24.2 \
    && pip install --no-cache-dir cloudpickle
