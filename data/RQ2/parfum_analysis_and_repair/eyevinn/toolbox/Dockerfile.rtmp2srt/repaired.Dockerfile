FROM eyevinntechnology/ffmpeg-base:0.3.0
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/rtmp2srt.py /root/rtmp2srt.py
ENTRYPOINT ["/root/rtmp2srt.py"]
CMD []