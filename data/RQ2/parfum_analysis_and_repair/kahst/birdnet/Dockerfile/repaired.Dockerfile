# Build from Python 3.7 slim
FROM python:3.7-slim

# Install required packages while keeping the image small
RUN apt-get update && apt-get install -y --no-install-recommends git ffmpeg build-essential gfortran libblas-dev liblapack-dev && rm -rf /var/lib/apt/lists/*

# Install required Python packages
RUN pip install --no-cache-dir numpy scipy librosa future

# Install Theano and Lasagne
RUN pip install --no-cache-dir -r https://raw.githubusercontent.com/Lasagne/Lasagne/master/requirements.txt
RUN pip install --no-cache-dir https://github.com/Lasagne/Lasagne/archive/master.zip

# Import all scripts
COPY . ./

# Fetch model
ADD https://tuc.cloud/index.php/s/m9smX4FkqmJaxLW/download ./model/BirdNET_Soundscape_Model.pkl

# Add entry point to run the script
ENTRYPOINT [ "python3", "./analyze.py" ]