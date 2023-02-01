FROM pytorch/pytorch

WORKDIR /reverb/speech_diarization

RUN apt-get update && apt-get install --no-install-recommends -y software-properties-common && rm -rf /var/lib/apt/lists/*;
RUN add-apt-repository ppa:jonathonf/ffmpeg-4
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get update

COPY requirements.txt requirements.txt

RUN pip install --no-cache-dir -r requirements.txt --ignore-installed

COPY server.py server.py
COPY diarization.py diarization.py

COPY model/*.py model/
COPY model/model.model model/model.model
COPY model/config model/config