FROM eyevinntechnology/ffmpeg-base:0.3.0
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/hls2srt.py /root/hls2srt.py
ENTRYPOINT ["/root/hls2srt.py"]
CMD []