FROM tensorflow/tensorflow:1.13.1-gpu-py3
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir numpy==1.14.5
RUN pip install --no-cache-dir scipy==0.19.1
RUN pip install --no-cache-dir scikit-learn==0.19.1
RUN pip install --no-cache-dir matplotlib==3.0.3
RUN pip install --no-cache-dir keras==2.2.4
RUN pip install --no-cache-dir librosa==0.5.1
RUN pip install --no-cache-dir pandas==0.20.3
RUN pip install --no-cache-dir munkres==1.0.7
RUN pip install --no-cache-dir pyannote.metrics==2.1
RUN pip install --no-cache-dir SIDEKIT==1.3.2
