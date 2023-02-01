FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "icalendar"]
RUN ["pip", "install", "pytz"]
CMD ["python", "snippet.py"]