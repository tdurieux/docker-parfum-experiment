FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "pymongo"]
RUN ["pip", "install", "tweepy"]
CMD ["python", "snippet.py"]