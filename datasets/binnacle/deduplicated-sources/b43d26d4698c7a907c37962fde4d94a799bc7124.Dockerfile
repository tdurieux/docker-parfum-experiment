FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "community"]
RUN ["pip", "install", "networkx"]
RUN ["pip", "install", "networkx"]
CMD ["python", "snippet.py"]