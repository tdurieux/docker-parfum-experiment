ARG PYTORCH="1.9.0"
ARG CUDA="11.1"
ARG CUDNN="8"

FROM pytorch/pytorch:${PYTORCH}-cuda${CUDA}-cudnn${CUDNN}-runtime

RUN apt update && \
    apt install --no-install-recommends -y \
    ffmpeg libsm6 libxext6 ninja-build libglib2.0-0 libsm6 libxrender-dev \
    gcc vim git watch && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt /project/requirements.txt

WORKDIR /project
RUN python -m pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

RUN jupyter notebook --generate-config && \
    echo "c.NotebookApp.notebook_dir = '/project'" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.token = ''" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.password = ''" >> ~/.jupyter/jupyter_notebook_config.py && \
    echo "c.NotebookApp.ip = '0.0.0.0'" >> ~/.jupyter/jupyter_notebook_config.py

CMD ["/bin/bash"]
