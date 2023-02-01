FROM tensorflow/tensorflow:1.15.0-gpu-py3-jupyter

RUN pip install --no-cache-dir scipy==1.3.3
RUN pip install --no-cache-dir requests==2.22.0
RUN pip install --no-cache-dir Pillow==6.2.1
RUN pip install --no-cache-dir h5py==2.9.0
RUN pip install --no-cache-dir imageio==2.9.0
RUN pip install --no-cache-dir imageio-ffmpeg==0.4.2
RUN pip install --no-cache-dir tqdm==4.49.0
