FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "flask"]
RUN ["pip", "install", "twilio"]
RUN ["pip", "install", "twilio"]
CMD ["python", "snippet.py"]