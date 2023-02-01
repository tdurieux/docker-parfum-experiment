FROM nvidia/cuda:11.0-base
RUN apt-get update && apt install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt-get update
RUN apt install --no-install-recommends -y python3.8 && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
COPY requirements_v2.txt /usr/local/bin
RUN pip3 install --no-cache-dir -r /usr/local/bin/requirements_v2.txt
RUN pip3 install --no-cache-dir torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html
COPY nnUNet/ /usr/local/bin/nnUNet/
COPY trained_models /usr/local/bin/trained_models/
RUN pip3 install --no-cache-dir -U setuptools
RUN pip3 install --no-cache-dir -e /usr/local/bin/nnUNet
ENV RESULTS_FOLDER=/usr/local/bin/trained_models/
COPY inference_v2.py /usr/local/bin

ENTRYPOINT ["python3", "/usr/local/bin/inference_v2.py"]