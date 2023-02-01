FROM python:3.5

ADD requirements.txt /
RUN pip install --no-cache-dir -r requirements.txt
ADD demo /demo
WORKDIR /
CMD ["hug", "-f", "/demo/app.py"]
EXPOSE 8000
