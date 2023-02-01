FROM python:3-slim-bullseye
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends -y ffmpeg python3-soundfile && rm -rf /var/lib/apt/lists/*;
WORKDIR /usr/lib/rvtool
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
COPY rvtool.py /usr/bin/rvtool
RUN chmod 755 /usr/bin/rvtool
ENTRYPOINT [ "python3", "/usr/bin/rvtool" ]
CMD [ "-h" ]
