FROM python:3.5

ADD app /app

RUN pip install --no-cache-dir --upgrade pip

COPY /build/amd64-requirements.txt ./
RUN pip install --no-cache-dir -r amd64-requirements.txt

# Expose the port
EXPOSE 80
EXPOSE 5679

# Set the working directory
WORKDIR /app

# Run the flask server for the endpoints
CMD python -u app.py