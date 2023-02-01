FROM ubuntu:18.04

RUN apt-get update \
  && apt-get install --no-install-recommends -y python3-pip python3-dev \
  && pip3 install --no-cache-dir --upgrade pip && rm -rf /var/lib/apt/lists/*;

COPY requirements.txt /requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY speech_emotion_recognition /speech_emotion_recognition

WORKDIR /

ENTRYPOINT ["python3"]
