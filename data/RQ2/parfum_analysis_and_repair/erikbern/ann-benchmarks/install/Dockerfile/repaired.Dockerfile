FROM ubuntu:18.04

RUN apt-get update && apt-get install --no-install-recommends -y python3-numpy python3-scipy python3-pip build-essential git && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir -U pip

WORKDIR /home/app
COPY requirements.txt run_algorithm.py ./
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "-u", "run_algorithm.py"]
