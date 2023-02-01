FROM tensorflow/tensorflow:2.5.0

WORKDIR /app/src
COPY . /app

RUN apt-get -y update
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev libgl1-mesa-glx && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -r /app/requirements.txt

CMD python3 main.py
