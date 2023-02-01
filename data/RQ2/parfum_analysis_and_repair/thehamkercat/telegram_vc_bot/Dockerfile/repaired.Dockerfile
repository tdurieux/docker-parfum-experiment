#Python based docker image
FROM python:3.9.5-buster

RUN apt-get update && apt-get upgrade -y

#Installing Requirements
RUN apt-get install --no-install-recommends -y ffmpeg python3-pip opus-tools && rm -rf /var/lib/apt/lists/*;

#Updating pip
RUN python3.9 -m pip install -U pip

COPY . .

RUN python3.9 -m pip install -U -r requirements.txt

#Running VCBot
CMD ["python3.9","main.py"]
