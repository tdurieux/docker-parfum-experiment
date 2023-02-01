FROM python:3

MAINTAINER Marcos Pablo Russo <marcospr1974@gmail.com>

RUN apt-get update -y \
 && apt-get install --no-install-recommends python3-pip git sudo -y \
 && git clone https://github.com/j1t3sh/SUB-Z.git \
 && cd /SUB-Z \
 && pip3 install --no-cache-dir -r requirements.txt && rm -rf /var/lib/apt/lists/*;

WORKDIR /SUB-Z

ENTRYPOINT ["python3", "Sub-Z.py"]
CMD ["-h"]
