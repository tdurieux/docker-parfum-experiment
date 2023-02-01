FROM continuumio/anaconda3:latest

RUN apt-get update
RUN apt-get upgrade -y

RUN apt install -y --no-install-recommends unzip && rm -rf /var/lib/apt/lists/*;
RUN apt install -y --no-install-recommends wget && rm -rf /var/lib/apt/lists/*;

RUN python -m pip install --upgrade pip
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir gdown

WORKDIR /mnt/work
CMD ["/bin/bash"]