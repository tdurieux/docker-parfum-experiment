FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "rdflib"]
RUN ["pip", "install", "rdflib"]
CMD ["python", "snippet.py"]