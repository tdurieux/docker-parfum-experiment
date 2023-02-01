FROM python:3.8.12-slim

# Update
RUN apt-get update -y && apt upgrade -y
RUN apt-get install --no-install-recommends patch gcc libffi-dev wget git -y && rm -rf /var/lib/apt/lists/*;

WORKDIR /code
COPY . /code

# Porter requirements
RUN pip3 install --no-cache-dir .[porter]

CMD ["/bin/bash"]
