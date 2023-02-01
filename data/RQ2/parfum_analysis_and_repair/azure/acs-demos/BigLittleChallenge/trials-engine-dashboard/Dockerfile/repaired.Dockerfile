FROM python

RUN pip install --no-cache-dir --upgrade pip

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 80

COPY src src

ENTRYPOINT [ "python", "src/server.py"]