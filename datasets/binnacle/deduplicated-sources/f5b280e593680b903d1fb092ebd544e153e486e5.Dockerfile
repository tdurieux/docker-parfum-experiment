FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "flask"]
RUN ["pip", "install", "tornado"]
RUN ["pip", "install", "tornado"]
RUN ["pip", "install", "tornado"]
RUN ["pip", "install", "tornado"]
RUN ["pip", "install", "os"]
RUN ["pip", "install", "tornado"]
CMD ["python", "snippet.py"]