FROM ubuntu:20.04

RUN apt-get update && apt-get install --no-install-recommends build-essential -y && rm -rf /var/lib/apt/lists/*;
# Set timezone:
RUN ln -snf /usr/share/zoneinfo/$CONTAINER_TIMEZONE /etc/localtime && echo $CONTAINER_TIMEZONE > /etc/timezone

# Install dependencies:
RUN apt-get update && apt-get install --no-install-recommends -y tzdata && rm -rf /var/lib/apt/lists/*;

RUN apt-get install --no-install-recommends python3-pip -y && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y libglib2.0-0 libsm6 libxrender1 libxext6 && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends libgl1 -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /home/picasso/

COPY . .

RUN pip install --no-cache-dir .

CMD ["bash"]
