FROM nvcr.io/nvidia/pytorch:20.03-py3
RUN mkdir /pip_installs

COPY  requirements.txt /workspace

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir 'git+https://github.com/facebookresearch/fvcore'
RUN pip install --no-cache-dir 'git+https://github.com/cocodataset/cocoapi.git#subdirectory=PythonAPI'

# Install Detectron2
RUN git clone https://github.com/facebookresearch/detectron2 /detectron2_repo
ENV FORCE_CUDA="1"
RUN pip install --no-cache-dir -e /detectron2_repo
# Add densepose to python path
ENV PYTHONPATH="${PYTHONPATH}:/detectron2_repo/projects/DensePose"

WORKDIR /workspace

RUN mkdir /pytorch_models
ENV TORCH_HOME=/workspace
RUN apt-get update && apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir addict albumentations face_detection
RUN pip install --no-cache-dir tensorflow==1.15
