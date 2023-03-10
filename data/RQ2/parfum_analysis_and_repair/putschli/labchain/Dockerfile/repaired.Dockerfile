# Use an official Python runtime as a parent image
FROM python:3.7-slim

# Set the working directory to /app
WORKDIR /app
COPY LabChain/ ./

RUN apt-get update && apt-get install --no-install-recommends -y git gcc net-tools && rm -rf /var/lib/apt/lists/*;

# Install any needed packages specified in requirements.txt
RUN pip install --no-cache-dir --upgrade pip
RUN pip3 install --no-cache-dir --trusted-host pypi.python.org -r requirements.txt

# Make port 8080 available to the world outside this container
EXPOSE 8080

# Define environment variable
ENV NAME LabChainEdge

# Run app.py when the container launches
CMD ["python3", "./node.py", "--port", "8080", "-v", "--peer-discovery"]
