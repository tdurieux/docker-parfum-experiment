FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "bs4"]
CMD ["python", "snippet.py"]