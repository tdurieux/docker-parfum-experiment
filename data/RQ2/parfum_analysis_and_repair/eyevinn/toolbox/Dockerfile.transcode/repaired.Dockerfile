FROM eyevinntechnology/ffmpeg-base:0.3.0
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/transcode.py /root/transcode.py
ENTRYPOINT ["/root/transcode.py"]
CMD []