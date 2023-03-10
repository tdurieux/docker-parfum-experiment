FROM python:3
FROM tensorflow/tensorflow:1.13.1-py3

WORKDIR /usr/src/app

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

RUN apt-get update && apt-get install --no-install-recommends -y \
    curl \
    unzip && rm -rf /var/lib/apt/lists/*;

RUN curl -f -L -o a.zip 'https://drive.google.com/uc?export=download&id=1GBHFd-fPIBWqJOpIC8ZO8g3F1LoIZYNn'
RUN unzip a.zip

COPY . .
# Reproduce the results of our paper.
# CMD [ "python", "./main.py", "./computation_graphs_and_TP_list/computation_graphs"]