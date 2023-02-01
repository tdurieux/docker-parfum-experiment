FROM python:3.4-alpine
WORKDIR /code
ADD . /code
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_APP app.py
CMD ["flask", "run","--host=0.0.0.0"]
