FROM alpine:3.5
RUN apk add --no-cache --update python py-pip
COPY requirements.txt /src/requirements.txt
RUN pip install --no-cache-dir -r /src/requirements.txt
COPY app.py /src
COPY buzz /src/buzz
CMD ["python", "/src/app.py"]
