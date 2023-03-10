FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-devel

RUN pip install --no-cache-dir pandas
RUN pip install --no-cache-dir scikit-image
RUN pip install --no-cache-dir scikit-learn
RUN pip install --no-cache-dir jupyterlab
RUN pip install --no-cache-dir opencv-python

# if use accimage
RUN pip install --no-cache-dir --prefix=/opt/intel/ipp ipp-devel
RUN pip install --no-cache-dir git+https://github.com/pytorch/accimage
ENV LD_LIBRARY_PATH=/opt/intel/ipp/lib:$LD_LIBRARY_PATH

# if use pillow-simd
RUN pip uninstall -y pillow
RUN CC="cc -mavx2" pip --no-cache-dir install -U --force-reinstall pillow-simd

RUN groupadd -g 1000 kamwoh
RUN useradd -g 1000 -u 1000 -ms /bin/bash kamwoh

USER kamwoh
WORKDIR /workspace