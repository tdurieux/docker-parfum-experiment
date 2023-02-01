FROM python:3.8
COPY . /tmp
WORKDIR tmp
RUN pip3 install --no-cache-dir -r requirements.txt
