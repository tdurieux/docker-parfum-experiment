FROM eyevinntechnology/ffmpeg-base:0.3.0
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/hls2rtmp.py /root/hls2rtmp.py
ENTRYPOINT ["/root/hls2rtmp.py"]
CMD []