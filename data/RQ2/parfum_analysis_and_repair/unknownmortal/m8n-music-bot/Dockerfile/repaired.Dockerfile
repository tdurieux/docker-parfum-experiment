FROM nikolaik/python-nodejs:python3.10-nodejs17
RUN apt-get update && apt-get upgrade -y
RUN apt-get install --no-install-recommends ffmpeg -y && rm -rf /var/lib/apt/lists/*;
COPY . /app/
WORKDIR /app/
RUN pip3 install --no-cache-dir -U pip
RUN pip3 install --no-cache-dir -U -r requirements.txt
CMD python3 -m m8n
