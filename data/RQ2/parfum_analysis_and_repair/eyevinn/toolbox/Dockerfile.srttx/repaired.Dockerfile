FROM eyevinntechnology/ffmpeg-base:0.3.0
MAINTAINER Eyevinn Technology <info@eyevinn.se>
COPY python/srttx.py /root/srttx.py
ENTRYPOINT ["/root/srttx.py"]
CMD []