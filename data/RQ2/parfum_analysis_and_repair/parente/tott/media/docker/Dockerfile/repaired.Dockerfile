FROM cellofellow/ffmpeg

RUN apt-get update && apt-get -y --no-install-recommends install python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir envoy
ADD convert.py /

ENTRYPOINT ["python", "/convert.py"]