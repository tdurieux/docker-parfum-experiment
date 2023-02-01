FROM tensorflow/tensorflow:2.5.0-gpu

WORKDIR /tmp

RUN apt-get update && apt-get install -y --no-install-recommends --assume-yes libsndfile1 libgl1-mesa-glx ffmpeg vim fluidsynth && rm -rf /var/lib/apt/lists/*;

COPY omnizart ./omnizart
COPY scripts ./scripts
COPY pyproject.toml ./
COPY poetry.lock ./
COPY README.md ./
COPY Makefile ./

RUN scripts/install.sh


# Upgrade this for avoiding mysterious import module not found 'keyrings'
RUN pip install --no-cache-dir --upgrade keyrings.alt

WORKDIR /home
RUN mv /tmp/omnizart /usr/local/lib/python3.6/dist-packages
RUN rm -rf /tmp
COPY README.md ./

CMD ["omnizart"]