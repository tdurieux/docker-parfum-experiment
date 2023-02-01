FROM tensorflow/tensorflow:latest-devel-gpu-py3
RUN apt-get update && apt-get install -y python-opencv python-tk vim
RUN pip install h5py keras pytest scikit-image seaborn tqdm gensim