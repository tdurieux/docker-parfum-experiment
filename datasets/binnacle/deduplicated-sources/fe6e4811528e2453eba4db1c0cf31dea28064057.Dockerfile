FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "flask"]
RUN ["pip", "install", "werkzeug"]
RUN ["pip", "install", "simplejson"]
CMD ["python", "snippet.py"]