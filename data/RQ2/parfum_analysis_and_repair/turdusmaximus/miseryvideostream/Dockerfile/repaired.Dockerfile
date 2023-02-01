FROM python:latest

RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;

COPY . /py
WORKDIR /py

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt

CMD python3 -m Misery
