FROM python:3.7-alpine
COPY . /app
WORKDIR /app
EXPOSE 80
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]
CMD ["helloworld.py"]