FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-devel

RUN apt-get update
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 libgl1-mesa-glx -y && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir jupyterlab
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir scikit-image
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir seaborn
RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir imutils
RUN pip install --no-cache-dir craft-text-detector
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir kornia
RUN pip install --no-cache-dir pytorch_memlab

RUN apt-get install --no-install-recommends bc unzip git -y && rm -rf /var/lib/apt/lists/*;

# if use accimage
RUN pip install --no-cache-dir --prefix=/opt/intel/ipp ipp-devel
RUN pip install --no-cache-dir git+https://github.com/pytorch/accimage
ENV LD_LIBRARY_PATH=/opt/intel/ipp/lib:$LD_LIBRARY_PATH

# if use pillow-simd
RUN pip uninstall -y pillow
RUN CC="cc -mavx2" pip --no-cache-dir install -U --force-reinstall pillow-simd

RUN pip install --no-cache-dir umap-learn

RUN pip install --no-cache-dir faiss-gpu

# setup user [ to avoid -u $(id -u):$(id -g) ]
RUN groupadd -g 1000 user
RUN useradd -g 1000 -u 1000 -ms /bin/bash user
EXPOSE 6006
EXPOSE 8123

USER user
WORKDIR /workspace
