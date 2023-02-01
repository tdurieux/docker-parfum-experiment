FROM python:3.8
WORKDIR /app
ADD app/requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
CMD python app.py
