FROM python:2.7.13
ADD snippet.py snippet.py
RUN ["pip", "install", "pickledb"]
RUN ["pip", "install", "simplejson"]
CMD ["python", "snippet.py"]