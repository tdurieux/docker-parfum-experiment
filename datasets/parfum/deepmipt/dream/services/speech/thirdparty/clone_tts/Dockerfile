FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

WORKDIR /app

COPY requirements.txt .
RUN pip install -r requirements.txt && \
    rm requirements.txt && \
    git clone https://github.com/CorentinJ/Real-Time-Voice-Cloning.git . && \
    git checkout 8f71d678d2457dffc4d07b52e75be11433313e15 && \
    pip install -r requirements.txt

RUN apt update && \
    apt install unzip \
                wget

RUN wget http://files.deeppavlov.ai/deeppavlov_data/nemo/voice_cloning/pretrained.zip && \
    unzip pretrained.zip && \
    rm pretrained.zip

RUN apt install -y libsndfile-dev

RUN wget http://files.deeppavlov.ai/deeppavlov_data/nemo/voice_cloning/gerty_sample.wav

COPY main.py .