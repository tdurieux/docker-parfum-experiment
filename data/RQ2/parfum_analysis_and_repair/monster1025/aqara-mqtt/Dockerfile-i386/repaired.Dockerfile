FROM monster1025/alpine86-python

ENV LIBRARY_PATH=/lib:/usr/lib

ADD src/requirements.txt /
RUN pip install --no-cache-dir --upgrade pip && pip install --no-cache-dir -r /requirements.txt

WORKDIR /app
COPY src /app

CMD ["python", "-u", "/app/main.py"]
