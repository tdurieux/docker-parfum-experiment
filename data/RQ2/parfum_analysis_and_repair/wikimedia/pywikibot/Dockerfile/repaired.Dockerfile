FROM python:3.8-slim

WORKDIR /code

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
RUN pip3 install --no-cache-dir .

ENV PYTHONPATH=/code:/code/scripts

ENTRYPOINT ["python", "/code/pwb.py"]
CMD ["version"]
