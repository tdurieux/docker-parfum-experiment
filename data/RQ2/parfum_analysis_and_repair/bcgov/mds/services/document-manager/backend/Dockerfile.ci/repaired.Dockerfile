FROM python:3.6

# Update installation utility
RUN apt-get update

# Create working directory
RUN mkdir /app
WORKDIR /app

# Install the requirements
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .
# Run the server
EXPOSE 5001

RUN mkdir -p /tmp/celery && chmod 777 /tmp/celery

ENTRYPOINT [ "./init.sh" ]