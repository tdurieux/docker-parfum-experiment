FROM python

RUN apt-get update && apt-get upgrade -y

RUN pip install --no-cache-dir --upgrade pip

RUN pip install --no-cache-dir keras
RUN pip install --no-cache-dir h5py

RUN apt-get clean
