FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "mongoengine"]
CMD ["python", "snippet.py"]