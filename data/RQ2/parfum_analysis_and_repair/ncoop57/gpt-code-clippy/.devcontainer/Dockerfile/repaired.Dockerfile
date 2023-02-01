from tensorflow/tensorflow:2.5.0-gpu

RUN apt update && apt install --no-install-recommends git vim python3.8 -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir datasets \
    git+https://github.com/huggingface/transformers \
    torch==1.9.0+cu111 -f https://download.pytorch.org/whl/torch_stable.html