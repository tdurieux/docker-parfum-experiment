FROM python:3.9

RUN apt update && apt upgrade -y
RUN apt install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;

COPY . /py
WORKDIR /py

RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -U -r requirements.txt

CMD python3 -m Bot
