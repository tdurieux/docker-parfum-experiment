FROM python:3.6


LABEL Name=meta-music Version=0.0.1
EXPOSE 5000

ADD ./requirements.txt /app/requirements.txt

WORKDIR /app


RUN apt-get -y update
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libportaudio2 && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r requirements.txt
RUN apt-get install --no-install-recommends -y nano && rm -rf /var/lib/apt/lists/*;
ADD . /app

CMD ["python3", "app.py"]


