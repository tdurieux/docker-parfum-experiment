# set base image (host OS)
FROM python:3.9

# set the working directory in the container
WORKDIR /app/

RUN apt -qq update && apt -qq install -y --no-install-recommends \
        ffmpeg && rm -rf /var/lib/apt/lists/*;

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# copy the content of the local src directory to the working directory
COPY . .

ENV ENV true

# command to run on container start
CMD [ "python", "-m", "mega" ]