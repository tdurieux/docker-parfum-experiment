FROM python:3-alpine
ENV PYTHONUNBUFFERED 1

# Add system dependencies
RUN apk update && apk add --no-cache postgresql-dev gcc python3-dev musl-dev libffi-dev make

# Allows docker to cache installed dependencies between builds
COPY Pipfile* ./
RUN pip install --no-cache-dir pipenv
RUN pipenv install --dev --system --deploy --ignore-pipfile

# Adds our application code to the image
COPY . /code/
WORKDIR /code

# Expose Django's port
EXPOSE $PORT
