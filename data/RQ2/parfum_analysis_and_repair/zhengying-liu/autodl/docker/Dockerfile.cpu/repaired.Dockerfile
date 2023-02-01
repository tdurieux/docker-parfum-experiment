FROM evariste/autodl:gpu-latest

# Overwrite the GPU version of TensorFlow to support environment with only CPU
RUN pip install --no-cache-dir tensorflow==1.13.1
