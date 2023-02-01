FROM tensorflow/tensorflow:2.1.0-gpu-py3
RUN pip install --no-cache-dir Cython==0.29.14
COPY build_tools/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
WORKDIR /usr/src/app
COPY sktime_dl sktime_dl

