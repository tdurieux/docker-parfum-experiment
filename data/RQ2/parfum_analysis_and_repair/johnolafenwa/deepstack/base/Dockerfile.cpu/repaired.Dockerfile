FROM python:3.7

RUN apt-get update -y
RUN apt-get install --no-install-recommends redis-server -y && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir --upgrade setuptools pip
RUN apt-get install --no-install-recommends libsm6 libxext6 libxrender1 libglib2.0-0 ffmpeg -y && rm -rf /var/lib/apt/lists/*;
