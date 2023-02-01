FROM tensorflow/tensorflow:2.7.1

ADD app.py .
ADD requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

ENV URL=""

# WORKDIR /opt
ENTRYPOINT ["python"]
CMD ["app.py"]