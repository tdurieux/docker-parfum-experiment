FROM python:3.6

WORKDIR /app
ADD . /app
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 8000
ENTRYPOINT ["python"]
CMD ["app.py"]