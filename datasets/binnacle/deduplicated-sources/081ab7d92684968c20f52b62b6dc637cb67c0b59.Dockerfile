FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "psutil"]
RUN ["pip", "install", "boto"]
RUN ["pip", "install", "boto"]
CMD ["python", "snippet.py"]