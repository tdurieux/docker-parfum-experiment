FROM python:3.7-slim-buster

RUN pip3 install --no-cache-dir --upgrade pip

WORKDIR /app/src
COPY . /app

RUN apt-get update && apt-get install --no-install-recommends libgl1-mesa-glx libglib2.0-0 libsm6 libxrender1 libxext6 -y && rm -rf /var/lib/apt/lists/*;

RUN pip3 install --no-cache-dir -r /app/requirements.txt

CMD python3 main.py
