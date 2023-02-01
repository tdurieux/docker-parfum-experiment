FROM python:3.9.7-slim

RUN apt-get update \
    && apt-get install --no-install-recommends -y \
        wget \
        unzip \
        libgl1-mesa-glx \
        libglu1-mesa \
        libgomp1 \
        libglib2.0-0 && rm -rf /var/lib/apt/lists/*;

COPY . neuromaps

RUN cd neuromaps \
    && python -m pip install .

RUN wget https://www.humanconnectome.org/storage/app/media/workbench/workbench-linux64-v1.5.0.zip \
    && unzip workbench-linux64-v1.5.0.zip -d "/"

ENV PATH="/workbench/bin_linux64:$PATH"

ENTRYPOINT [ "python3" ]
