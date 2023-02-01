# Use the official image as a parent image
FROM ubuntu:latest

# Ref: https://rtfm.co.ua/en/docker-configure-tzdata-and-timezone-during-build/
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set the working directory
WORKDIR /usr/src/app

# Install any needed packages specified in requirements.txt
RUN apt-get update
RUN apt-get install --no-install-recommends -y pkg-config && rm -rf /var/lib/apt/lists/*;
RUN apt install --no-install-recommends -y python3-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y python3-pip && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libavformat-dev libavdevice-dev && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libsm6 libxext6 libxrender-dev && rm -rf /var/lib/apt/lists/*;
# RUN pip install av
RUN pip3 install --no-cache-dir av==6.1.2
RUN pip3 install --no-cache-dir opencv-python
RUN pip3 install --no-cache-dir tellopy

# Copy the rest of your app's source code from your host to your image filesystem.
COPY . .

# Run hellopy controller
CMD ["python3","./hallopy/hallo.py"]
