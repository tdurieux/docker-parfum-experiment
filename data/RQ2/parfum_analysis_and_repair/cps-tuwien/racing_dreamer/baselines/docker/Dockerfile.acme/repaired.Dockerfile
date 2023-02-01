FROM tensorflow/tensorflow:2.4.1-gpu
RUN apt update && apt install --no-install-recommends -y git wget && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --user dm-acme \
    && pip install --no-cache-dir --user dm-acme[jax] \
    && pip install --no-cache-dir --user dm-acme[envs] \
    && pip install --no-cache-dir --user dm-reverb jax tensorflow_probability trfl dm-sonnet imageio imageio-ffmpeg dataclasses optuna plotly kaleido pymysql pyyaml
RUN wget https://github.com/axelbr/racecar_gym/releases/download/tracks-v1.0.0/all.zip
RUN git clone https://github.com/axelbr/racecar_gym.git
RUN pip install --no-cache-dir --user -e racecar_gym/
RUN mv all.zip racecar_gym/models/scenes/ && cd racecar_gym/models/scenes/ && unzip all.zip
WORKDIR /app
COPY . .
