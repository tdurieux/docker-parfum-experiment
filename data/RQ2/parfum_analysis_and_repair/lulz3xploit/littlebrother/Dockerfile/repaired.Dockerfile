FROM python:3

COPY . .
RUN pip3 install --no-cache-dir -r requirements.txt

ENTRYPOINT ["python3", "./LittleBrother.py"]
