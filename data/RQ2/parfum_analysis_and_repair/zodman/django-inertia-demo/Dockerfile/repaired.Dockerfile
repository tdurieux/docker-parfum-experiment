FROM python:3
ENV PYTHONUNBUFFERED 1
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install --no-cache-dir -r requirements.txt
COPY . /code/
EXPOSE 8000
RUN python manage.py migrate
RUN python populate.py
CMD ["python","manage.py","gunicorn", "-b","0:8000"]
