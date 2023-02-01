FROM python:3.8-slim-buster
WORKDIR /app
COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
COPY . .

CMD python3 main.py
