FROM pytorch/pytorch:1.6.0-cuda10.1-cudnn7-runtime
RUN apt update && apt install --no-install-recommends -y git wget unzip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --user imageio imageio-ffmpeg dataclasses pyyaml stable-baselines3 tensorboard 'numpy>=1.18.0' 'cloudpickle<1.7.0' optuna pymysql sklearn plotly kaleido
RUN wget https://github.com/axelbr/racecar_gym/releases/download/tracks-v1.0.0/all.zip
RUN git clone https://github.com/axelbr/racecar_gym.git
RUN pip install --no-cache-dir --user -e racecar_gym/
RUN mv all.zip racecar_gym/models/scenes/ && cd racecar_gym/models/scenes/ && unzip all.zip
WORKDIR /app
COPY . .