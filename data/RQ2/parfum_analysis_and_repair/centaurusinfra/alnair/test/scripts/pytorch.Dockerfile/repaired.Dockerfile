FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-devel
RUN apt-get update && apt-get install --no-install-recommends -y git vim && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y cuda-toolkit-11-4 && rm -rf /var/lib/apt/lists/*;

RUN pip install --no-cache-dir scipy dataset pytorch-ignite matplotlib seaborn
RUN mkdir /root/{data,logs,scripts}
WORKDIR /root/scripts

COPY ./pyt-fashion-cnn-pack-low.py .
COPY ./pyt-cf-rn50-pack-medium.py .
COPY ./pyt-cf-inc-pack-high.py .
CMD ["python", "pyt-fashion-cnn-pack-low.py"]

