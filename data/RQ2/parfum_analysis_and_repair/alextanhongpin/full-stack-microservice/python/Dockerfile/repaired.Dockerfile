FROM python:3
MAINTAINER Alex Tan Hong Pin "alextan220990@gmail.com"
COPY . /app
WORKDIR /app
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["main.py"]