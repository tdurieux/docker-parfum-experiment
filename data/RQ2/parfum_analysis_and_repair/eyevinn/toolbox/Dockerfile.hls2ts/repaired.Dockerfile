FROM eyevinntechnology/ffmpeg-base:0.2.2
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/hls2ts.py /root/hls2ts.py
ENTRYPOINT ["/root/hls2ts.py"]
CMD []