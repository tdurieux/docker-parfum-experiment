FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "bitarray"]
CMD ["python", "snippet.py"]