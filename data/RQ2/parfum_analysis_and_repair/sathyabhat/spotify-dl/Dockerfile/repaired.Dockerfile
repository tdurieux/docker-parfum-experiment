# Use an official Python runtime as a base image
FROM python:3.8-slim

# Install any needed packages specified in requirements.txt
RUN apt-get update && apt-get install --no-install-recommends -y ffmpeg && rm -rf /var/lib/apt/lists/*;
RUN pip3 install --no-cache-dir spotify_dl --upgrade

# Define environment variable
ENV SPOTIPY_CLIENT_ID=
ENV SPOTIPY_CLIENT_SECRET=
