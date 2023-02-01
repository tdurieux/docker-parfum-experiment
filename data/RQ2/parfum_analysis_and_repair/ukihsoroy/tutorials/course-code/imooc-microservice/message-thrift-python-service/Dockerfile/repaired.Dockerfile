FROM python-base:latest
MAINTAINER K.O ko.shen@hotmail.com

ENV PYTHONPATH /
COPY message /message

ENTRYPOINT ["python", "/message/message_service.py"]