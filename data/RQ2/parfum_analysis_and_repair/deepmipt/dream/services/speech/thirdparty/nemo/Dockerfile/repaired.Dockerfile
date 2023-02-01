FROM pytorch/pytorch:1.4-cuda10.1-cudnn7-devel

WORKDIR /app

RUN apt update && apt install --no-install-recommends -y libsndfile-dev && rm -rf /var/lib/apt/lists/*;

COPY . .

RUN pip install --no-cache-dir deeppavlov==0.12.1 && \
    python -m deeppavlov install asr_tts && \
    python -m deeppavlov download asr.json && \
    python -m deeppavlov download tts.json

RUN pip install --no-cache-dir -r requirements.txt