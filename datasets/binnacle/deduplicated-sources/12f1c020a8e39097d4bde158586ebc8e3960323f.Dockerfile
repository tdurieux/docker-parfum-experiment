FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "requests"]
RUN ["pip", "install", "selenium"]
RUN ["pip", "install", "selenium"]
RUN ["pip", "install", "os"]
RUN ["pip", "install", "selenium"]
CMD ["python", "snippet.py"]