FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "redis"]
RUN ["pip", "install", "redis"]
CMD ["python", "snippet.py"]