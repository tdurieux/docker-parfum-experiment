FROM --platform=$TARGETPLATFORM python:alpine

WORKDIR /
ADD . /
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000
CMD ["python", "app.py"]