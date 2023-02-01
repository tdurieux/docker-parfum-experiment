FROM python:3

WORKDIR /

RUN git clone https://github.com/knavesec/CredMaster
WORKDIR /CredMaster
RUN pip3 install --no-cache-dir -r requirements.txt
RUN chmod +x /CredMaster/credmaster.py

ENTRYPOINT ["./credmaster.py"]
