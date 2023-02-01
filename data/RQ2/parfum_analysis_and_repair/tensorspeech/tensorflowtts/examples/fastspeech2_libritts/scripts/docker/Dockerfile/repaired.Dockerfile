FROM tensorflow/tensorflow:2.2.0-gpu
RUN apt-get update && apt-get install --no-install-recommends -y zsh tmux wget git libsndfile1 && rm -rf /var/lib/apt/lists/*;
ADD . /workspace/tts
WORKDIR /workspace/tts
RUN pip install --no-cache-dir .

