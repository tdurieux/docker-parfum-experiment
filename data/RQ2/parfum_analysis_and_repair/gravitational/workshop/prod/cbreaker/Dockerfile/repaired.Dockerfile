FROM library/python:2.7

RUN pip install --no-cache-dir flask requests
ADD weather.py /weather.py
ADD mail.py /mail.py
ADD frontend.py /frontend.py
