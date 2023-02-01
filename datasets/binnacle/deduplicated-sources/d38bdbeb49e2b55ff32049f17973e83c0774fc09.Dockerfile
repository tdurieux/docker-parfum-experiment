FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "matplotlib"]
RUN ["pip", "install", "numpy"]
RUN ["pip", "install", "pandas"]
CMD ["python", "snippet.py"]