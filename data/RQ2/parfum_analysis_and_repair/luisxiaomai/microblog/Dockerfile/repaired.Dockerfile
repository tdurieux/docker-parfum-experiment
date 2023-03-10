FROM python:3
copy . /app
WORKDIR /app
RUN pip install --no-cache-dir -r requirements.txt
ENTRYPOINT [ "python", "manage.py"]
CMD ["runserver", "--host", "0.0.0.0"]