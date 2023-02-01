FROM continuumio/anaconda3:latest
FROM tensorflow/tensorflow:latest-gpu-py3

RUN apt-get update && apt-get install --no-install-recommends -y libasound-dev portaudio19-dev libportaudio2 libportaudiocpp0 ffmpeg libav-tools wget git vim && rm -rf /var/lib/apt/lists/*;

RUN wget https://data.keithito.com/data/speech/LJSpeech-1.1.tar.bz2
RUN tar -jxvf LJSpeech-1.1.tar.bz2 && rm LJSpeech-1.1.tar.bz2

RUN git clone https://github.com/Rayhane-mamah/Tacotron-2.git

WORKDIR Tacotron-2
RUN ln -s ../LJSpeech-1.1 .
RUN pip install --no-cache-dir -r requirements.txt