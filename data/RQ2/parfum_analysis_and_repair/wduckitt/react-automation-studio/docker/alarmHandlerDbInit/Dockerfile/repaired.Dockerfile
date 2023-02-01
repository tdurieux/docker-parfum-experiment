FROM python:3.8.7

ADD ./alarmHandlerDbInit alarmHandlerDbInit
WORKDIR /alarmHandlerDbInit

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python","main.py"]