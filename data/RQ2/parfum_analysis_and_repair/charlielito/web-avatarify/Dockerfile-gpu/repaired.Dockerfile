FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-runtime

WORKDIR /code

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    ffmpeg \
    locales \
    && apt-get -y clean all \
    && rm -rf /var/lib/apt/lists/*

RUN locale-gen en_US.UTF-8
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

COPY requirements-gpu.txt .
RUN pip install --no-cache-dir -r requirements-gpu.txt

RUN git clone https://github.com/alievk/first-order-model.git fomm
RUN cd fomm && git checkout efbe0a6f17b38360ff9a446fddfbb3ce5493534c && cd ..

WORKDIR /code
COPY download_model.py .
RUN python download_model.py

COPY app ./app
COPY afy ./afy
RUN mkdir app/static

CMD uvicorn app.server:app --port $PORT --workers 1 --host 0.0.0.0