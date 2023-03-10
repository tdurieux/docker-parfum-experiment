#Import Python runtime and set up working directory
FROM python:2.7-slim
WORKDIR /app
ADD . /app

# Install any necessary dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Open port 4738 for serving the webpage
EXPOSE 4738

# Run app.py when the container launches
CMD ["python", "app.py"]

