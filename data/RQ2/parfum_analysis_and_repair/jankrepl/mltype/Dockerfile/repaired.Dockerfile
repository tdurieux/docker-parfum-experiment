FROM pytorch/pytorch:1.7.0-cuda11.0-cudnn8-runtime
COPY . /mltype
RUN pip install --no-cache-dir /mltype
ENTRYPOINT ["/bin/bash"]
