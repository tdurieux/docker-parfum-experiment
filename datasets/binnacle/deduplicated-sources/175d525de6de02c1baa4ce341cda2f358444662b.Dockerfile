FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "twitter"]
RUN ["pip", "install", "os"]
CMD ["python", "snippet.py"]