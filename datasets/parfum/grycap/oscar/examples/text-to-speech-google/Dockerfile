FROM ubuntu:20.04
RUN apt-get update && \
	apt-get install -y --no-install-recommends python3 \
				python3-pip \
				sox \
				ffmpeg libsm6 libxext6
RUN pip3 install google-speech

COPY tts.py /opt/tts.py

ENTRYPOINT ["python3","/opt/tts.py" "--language=","$language","-o","$OUTPUT_FILE","$INPUT_FILE_PATH"]
