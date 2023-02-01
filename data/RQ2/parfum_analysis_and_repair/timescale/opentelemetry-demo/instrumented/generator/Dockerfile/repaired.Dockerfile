FROM python:latest
WORKDIR /code
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt
COPY generator.py .
EXPOSE 5000
ENV FLASK_APP=generator
CMD ["flask", "run", "--host=0.0.0.0"]
