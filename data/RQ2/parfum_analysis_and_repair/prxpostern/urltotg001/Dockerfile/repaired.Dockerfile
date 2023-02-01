FROM python:3.9.2-slim-buster
RUN mkdir /bot && chmod 777 /bot
WORKDIR /bot
ENV DEBIAN_FRONTEND=noninteractive
RUN apt -qq update && apt -qq --no-install-recommends install -y git wget pv jq wget python3-dev ffmpeg mediainfo && rm -rf /var/lib/apt/lists/*;
COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt
CMD ["bash","run.sh"]
