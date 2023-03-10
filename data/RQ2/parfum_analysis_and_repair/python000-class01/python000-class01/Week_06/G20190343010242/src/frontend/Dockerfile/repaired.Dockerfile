# Use base Python image from Docker Hub
FROM python:3.7

# Set the working directory to /app
WORKDIR /app

# copy the requirements file used for dependencies
COPY requirements.txt .

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Install ptvsd for debugging
RUN pip install --no-cache-dir ptvsd

# Copy the rest of the working directory contents into the container at /app
COPY . .

# Run app.py when the container launches
ENTRYPOINT ["python", "-m", "ptvsd", "--port", "3000", "--host", "0.0.0.0", "app.py"]
