FROM python:2

ADD SDS011.py /

RUN pip install --no-cache-dir pyserial paho-mqtt

# CMD [ "python", "./SDS011.py" ]
CMD python -u SDS011.py
