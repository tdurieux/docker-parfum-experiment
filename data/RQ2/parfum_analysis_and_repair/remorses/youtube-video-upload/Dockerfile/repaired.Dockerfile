FROM python:3.6-alpine

COPY requirements.txt /

RUN pip install --no-cache-dir -r /requirements.txt

WORKDIR /youtube-video-uploader

COPY . .

CMD [ "sh", "./run_tests.sh" ]
