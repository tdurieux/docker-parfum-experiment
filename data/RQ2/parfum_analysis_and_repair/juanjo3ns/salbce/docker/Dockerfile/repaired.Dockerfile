FROM tensorflow/tensorflow:latest-gpu-py3
WORKDIR /home
ADD requirements.txt .
RUN apt update -y; apt install --no-install-recommends -y \
	libsm6 \
	libxext6 \
	libxrender-dev && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r requirements.txt
