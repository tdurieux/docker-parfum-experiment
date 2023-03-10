FROM python:3

WORKDIR /usr/src/ytsm/app

# ffmpeg is needed for youtube-dl
RUN apt-get update && apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

COPY ./requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

ENV YTSM_DEBUG='False'
ENV YTSM_DATA_DIR='/usr/src/ytsm/data'

VOLUME /usr/src/ytsm/data
VOLUME /usr/src/ytsm/download

COPY ./app/ ./
COPY ./config/ ./
COPY ./docker/init.sh ./

EXPOSE 8000

CMD ["/bin/bash", "init.sh"]
