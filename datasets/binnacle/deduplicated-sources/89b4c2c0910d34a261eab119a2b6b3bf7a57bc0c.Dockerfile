FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "area53"]
RUN ["pip", "install", "requests"]
RUN ["pip", "install", "boto"]
CMD ["python", "snippet.py"]