FROM python:3.6
FROM ubuntu:18.04

MAINTAINER fnndsc "vijay.yadav@aicure.com"

RUN apt-get update && apt-get install --no-install-recommends -y python3-pip \
                   && apt-get install --no-install-recommends -y wget \
                   && apt-get install --no-install-recommends -y automake --upgrade \
                   && apt-get install --no-install-recommends -y libtool --upgrade \
                   && apt-get -y --no-install-recommends install ffmpeg \
                   && apt-get install --no-install-recommends -y lsb-core \
                   && apt-get install --no-install-recommends -y libavcodec-dev \
                   && apt-get install --no-install-recommends -y libavformat-dev \
                   && apt-get install --no-install-recommends -y libavdevice-dev \
                   && apt-get install --no-install-recommends -y libboost-all-dev \
                   && apt-get install --no-install-recommends -y git \
                   && apt-get install --no-install-recommends -y sox && rm -rf /var/lib/apt/lists/*;
RUN ln -sfn /usr/bin/pip3 /usr/bin/pip

COPY . /app

#cloning openface
WORKDIR /app/pkg
RUN git clone https://github.com/AiCure/open_dbm.git -b openface

RUN echo "Installing OpenFace..."
WORKDIR /app/pkg/open_dbm/OpenFace
RUN bash ./download_models.sh
RUN dpkg --configure -a
RUN su -c ./install.sh
RUN echo "Done OpenFace!"

RUN echo "Cloning DeepSpeech..."
WORKDIR /app/pkg
RUN git clone https://github.com/mozilla/DeepSpeech.git

WORKDIR /app/pkg/DeepSpeech
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.pbmm
RUN wget https://github.com/mozilla/DeepSpeech/releases/download/v0.9.1/deepspeech-0.9.1-models.scorer

WORKDIR /app
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN echo "Requirement txt done!"

CMD [ "python", "./process_data.py" ]
