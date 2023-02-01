FROM python
RUN pip install --no-cache-dir requests
RUN pip install --no-cache-dir flask
COPY . /app
WORKDIR /app
ENTRYPOINT ["python"]
CMD ["app.py"]