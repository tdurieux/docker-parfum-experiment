FROM python:3.8.9
WORKDIR /app

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt
ENV FLASK_ENV production

COPY . .

EXPOSE 5000
CMD ["gunicorn", "--timeout", "1000", "-b", ":5000", "manage:app"]