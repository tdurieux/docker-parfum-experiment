FROM python:3.8

LABEL maintainer="db225@qq.com"
COPY . /pa
RUN pip install --no-cache-dir -r /pa/requirements.txt
CMD ["sh", "/pa/run.sh"]