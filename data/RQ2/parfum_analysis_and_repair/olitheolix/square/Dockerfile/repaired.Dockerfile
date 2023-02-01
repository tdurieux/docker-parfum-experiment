FROM python:3.7.7-slim

# Install Pip and Pipenv.
RUN apt update && apt install --no-install-recommends -y git && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir pipenv pip --upgrade

# Clone the repository.
RUN git clone https://github.com/olitheolix/square.git --depth=1 /square
WORKDIR /square

# Install the dependencies for Square.
RUN pipenv install --system

# Allow convenient execution of Square in Docker.
ENTRYPOINT ["python", "runme.py"]
CMD ["-h"]
