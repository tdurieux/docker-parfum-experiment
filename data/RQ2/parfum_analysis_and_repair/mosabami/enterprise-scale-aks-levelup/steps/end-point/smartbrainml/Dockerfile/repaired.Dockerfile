#Download Python from DockerHub and use it
FROM python:3.7.4
#Set the working directory in the Docker container
WORKDIR /code
#Copy the dependencies file to the working directory
COPY requirements.txt .
RUN apt-get update ##[edited]
RUN apt-get install --no-install-recommends ffmpeg libsm6 libxext6 -y && rm -rf /var/lib/apt/lists/*;

RUN apt-get update && apt-get install --no-install-recommends -y python3-opencv && rm -rf /var/lib/apt/lists/*;
#Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt
RUN pip install --no-cache-dir opencv-python
RUN pip install --no-cache-dir --upgrade tensorflow

#Copy the Flask app code to the working directory
COPY src/ .
#Run the container
EXPOSE 2000
CMD [ "python", "./app.py" ]