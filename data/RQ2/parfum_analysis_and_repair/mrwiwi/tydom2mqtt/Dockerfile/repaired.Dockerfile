FROM python:3.10-alpine

# App base dir
WORKDIR /app

# Copy app
COPY /app .

# Install dependencies
RUN pip3 install --no-cache-dir -r requirements.txt

# Main command
CMD [ "python", "-u", "main.py" ]