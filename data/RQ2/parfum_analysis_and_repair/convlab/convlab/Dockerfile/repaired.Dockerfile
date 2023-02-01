FROM pytorch/pytorch:1.1.0-cuda10.0-cudnn7.5-devel

# Install base packages.
RUN apt-get clean && apt-get update && apt-get install --no-install-recommends -y locales && rm -rf /var/lib/apt/lists/*;

RUN apt-get update --fix-missing && apt-get install --no-install-recommends -y \
    xvfb \
    bzip2 \
    ca-certificates \
    curl \
    gcc \
    git \
    libc-dev \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender1 \
    wget \
    libevent-dev \
    build-essential \
    openjdk-8-jdk && \
rm -rf /var/lib/apt/lists/*

COPY requirements.txt .
RUN pip install --no-cache-dir --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt
RUN [ "python", "-c", "import nltk; nltk.download('stopwords')" ]

WORKDIR /root

CMD ["/bin/bash"]
