FROM python:3.8.7-slim
RUN apt-get update -y && apt-get upgrade -y && apt-get install --no-install-recommends gcc git -y && rm -rf /var/lib/apt/lists/*;
# make a separate layer for the ffmpeg related stuff
RUN apt-get install --no-install-recommends ffmpeg libavcodec58 libavformat58 libavresample4 libavutil56 python-numpy -y && rm -rf /var/lib/apt/lists/*;
COPY . /YAPO
WORKDIR /YAPO
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r requirements.txt && rm -r ~/.cache/pip
EXPOSE 8000
ENTRYPOINT ["/bin/bash", "/YAPO/yapo.sh"]
