FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "pexpect"]
RUN ["pip", "install", "pexpect"]
CMD ["python", "snippet.py"]