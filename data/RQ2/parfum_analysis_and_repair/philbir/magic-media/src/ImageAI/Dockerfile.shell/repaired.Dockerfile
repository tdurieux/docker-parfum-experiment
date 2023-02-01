FROM python:3.5

RUN pip install --no-cache-dir --upgrade pip && \
  pip install --no-cache-dir numpy && \
  pip install --no-cache-dir scipy && \
  pip install --no-cache-dir opencv-python && \
  pip install --no-cache-dir --upgrade ptvsd && \
  pip3 install --no-cache-dir tensorflow==1.15 && \
  pip3 install --no-cache-dir pillow && \
  pip3 install --no-cache-dir matplotlib && \
  pip3 install --no-cache-dir h5py && \
  pip3 install --no-cache-dir keras==2.2.4 && \
  pip3 install --no-cache-dir https://github.com/OlafenwaMoses/ImageAI/releases/download/2.1.0/imageai-2.1.0-py3-none-any.whl

RUN apt update && apt install --no-install-recommends libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir requests

RUN rm -f /app/models/resnet50_coco_best_v2.0.1.h5 && \
  rm -f /app/models/resnet50_weights_tf_dim_ordering_tf_kernels.h5

ADD https://github.com/OlafenwaMoses/ImageAI/releases/download/1.0/resnet50_coco_best_v2.0.1.h5 /app/models/
ADD https://github.com/OlafenwaMoses/ImageAI/releases/download/1.0/resnet50_weights_tf_dim_ordering_tf_kernels.h5 /app/models/

