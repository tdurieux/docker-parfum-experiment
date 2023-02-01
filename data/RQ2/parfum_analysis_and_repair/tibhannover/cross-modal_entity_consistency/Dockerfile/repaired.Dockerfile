FROM tensorflow/tensorflow:1.15.2-gpu-py3
MAINTAINER TIB-Visual-Analytics

ENV PYTHONUNBUFFERED=1
RUN apt install --no-install-recommends wget -y && rm -rf /var/lib/apt/lists/*;
RUN apt-key del 7fa2af80
RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub

RUN DEBIAN_FRONTEND=noninteractive apt-get update -y
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install libsm6 libxext6 libxrender-dev -y && rm -rf /var/lib/apt/lists/*;
RUN DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install python-opencv -y && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip

# Install pip requirements
COPY requirements.txt .
RUN python -m pip install -r requirements.txt

RUN python -m spacy download en_core_web_sm
RUN python -m spacy download de_core_news_sm
