FROM python:3.7
WORKDIR /code
COPY ./requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
ARG WEEDCOCO_VERSION=master
ADD "http://github.com/Weed-AI/Weed-AI/archive/"$WEEDCOCO_VERSION".zip" /tmp/weedcoco.zip
RUN pip install --no-cache-dir /tmp/weedcoco.zip
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
