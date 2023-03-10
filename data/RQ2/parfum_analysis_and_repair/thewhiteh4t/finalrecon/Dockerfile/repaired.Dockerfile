FROM alpine:3.15.4
RUN apk update
RUN apk add --no-cache \
git \
python3 \
py3-pip gcc \
python3-dev \
postgresql-dev \
libffi-dev \
musl-dev \
libxml2-dev \
libxslt-dev
RUN rm -rf /var/cache/apk/*
WORKDIR /root
RUN git clone https://github.com/thewhiteh4t/finalrecon.git
WORKDIR /root/finalrecon/
RUN pip3 install --no-cache-dir wheel
RUN pip3 install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python3", "finalrecon.py"]
