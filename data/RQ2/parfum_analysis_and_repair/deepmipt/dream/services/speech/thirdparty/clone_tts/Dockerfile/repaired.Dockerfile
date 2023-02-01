FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt && \
    rm requirements.txt && \
    git clone https://github.com/CorentinJ/Real-Time-Voice-Cloning.git . && \
    git checkout 8f71d678d2457dffc4d07b52e75be11433313e15 && \
    pip install --no-cache-dir -r requirements.txt

RUN apt update && \
    apt install -y --no-install-recommends unzip \
                wget && rm -rf /var/lib/apt/lists/*;

RUN wget https://files.deeppavlov.ai/deeppavlov_data/nemo/voice_cloning/pretrained.zip && \
    unzip pretrained.zip && \
    rm pretrained.zip

RUN apt install --no-install-recommends -y libsndfile-dev && rm -rf /var/lib/apt/lists/*;

RUN wget https://files.deeppavlov.ai/deeppavlov_data/nemo/voice_cloning/gerty_sample.wav

COPY main.py .