FROM python:3-alpine
COPY . /python
WORKDIR /python
RUN pip install --no-cache-dir -r requirements.txt
CMD python /python/app.py
