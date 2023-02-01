FROM python:3.7

# copy all files
RUN mkdir hello
COPY . /hello
WORKDIR /hello

# install required libraries
RUN pip install --no-cache-dir Flask
RUN pip install --no-cache-dir Flask_Script

EXPOSE 5000

CMD ["python", "run.py"]