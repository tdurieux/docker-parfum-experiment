FROM python:3

COPY  ./src/light_controller /app
COPY requirements.txt /app


WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT ["python"]

EXPOSE 8000


CMD ["server.py"]