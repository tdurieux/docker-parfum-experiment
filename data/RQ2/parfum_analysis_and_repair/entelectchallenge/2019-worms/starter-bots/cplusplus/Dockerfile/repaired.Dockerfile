FROM entelectchallenge/base:2019

# Needed for building non Windows host using Windows Docker
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update everything
RUN apt-get update -y && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*; # Install all build tools, including g++


# Set the working directory to /app
WORKDIR /cppbot

# Copy the current directory contents into the container at /app
COPY . /cppbot

RUN cd /cppbot

RUN make