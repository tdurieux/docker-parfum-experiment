FROM ubuntu:18.04

LABEL name='pygmy'
LABEL version='1.0.0'
LABEL description='Pygmy(pygy.co) URL shortener'
LABEL vendor="Amit Tripathi"

RUN apt update && apt install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN mkdir /var/log/pygmy

WORKDIR /pygmy
ADD ./requirements.txt /pygmy/requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt
ADD . /pygmy

EXPOSE 8000

CMD ["python3", "run.py"]
