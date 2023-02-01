FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime
RUN pip install --no-cache-dir sklearn opencv-python
RUN pip install --no-cache-dir matplotlib
RUN pip install --no-cache-dir wandb
RUN pip install --no-cache-dir ipdb
ENTRYPOINT wandb login $WANDB_KEY && /bin/bash
