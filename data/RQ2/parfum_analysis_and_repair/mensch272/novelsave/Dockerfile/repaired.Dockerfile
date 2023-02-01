FROM python:3.9
RUN mkdir /app
WORKDIR /app
ADD . /app/
RUN pip install --no-cache-dir -r requirements.txt
CMD ["python", "-m", "novelsave", "runbot", "discord"]
