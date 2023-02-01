FROM python:3.8
ADD . /
ENV OKTETO=true
RUN pip install --no-cache-dir -r requirements.txt
RUN apt update && apt install --no-install-recommends ffmpeg libavcodec-dev libavutil-dev libavformat-dev libswscale-dev libavdevice-dev -y && rm -rf /var/lib/apt/lists/*;
EXPOSE 8080
RUN mkdir /data
CMD ["python3", "-m", "friendly-telegram"]