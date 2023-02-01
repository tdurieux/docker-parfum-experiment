FROM continuumio/miniconda3

# Install linux dependencies
RUN apt-get update -y
RUN apt install --no-install-recommends -y build-essential && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y swig && rm -rf /var/lib/apt/lists/*;
RUN apt-get install --no-install-recommends -y redis-server && rm -rf /var/lib/apt/lists/*;

# Copy files
COPY . /DeepCAVE
WORKDIR /DeepCAVE

RUN conda update conda -y

# Create new environment
RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
SHELL ["conda", "run", "-n", "DeepCAVE", "/bin/bash", "-c"]

# Install DeepCAVE
RUN pip install --no-cache-dir .