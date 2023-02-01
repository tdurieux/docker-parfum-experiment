FROM python:2.7.12

COPY . /home/shico
WORKDIR /home/shico
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

CMD /home/shico/dockerRun.sh
