FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "pycurl2"]
RUN ["pip", "install", "pycurl"]
CMD ["python", "snippet.py"]