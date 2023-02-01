FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/3bf863cc.pub
RUN apt-get -y update && apt-get install --no-install-recommends -y python3-pip software-properties-common wget ffmpeg && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /
RUN pip install --no-cache-dir --upgrade pip setuptools wheel
RUN pip install --no-cache-dir -r /requirements.txt
# RUN gdown https://drive.google.com/uc?id=1czUSFvk6Z49H-zRikTc67g2HUUz4imON
# RUN unzip log.zip
# RUN rm log.zip
ADD log log
ADD dfp dfp
COPY resources /usr/local/resources
RUN mv /usr/local/resources .

CMD ["python","dfp/app.py"]

EXPOSE 1111
