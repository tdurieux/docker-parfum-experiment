FROM python:3.6.7

# set a directory for the app
WORKDIR /workspace

# copy all the files to the container
COPY . .

# install dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir --upgrade pip
RUN apt-get -y --no-install-recommends install libsndfile-dev && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir -r gesticulator/requirements.txt
RUN pip install --no-cache-dir -e .
RUN pip install --no-cache-dir -e gesticulator/visualization