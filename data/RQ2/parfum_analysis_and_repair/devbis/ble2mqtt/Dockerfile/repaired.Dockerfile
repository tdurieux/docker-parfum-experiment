# First stage, build requirements
FROM python:3.9-slim as builder

RUN apt-get update && \
    apt-get install --no-install-recommends gcc git -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

WORKDIR /usr/src/app

# To speed up consecutive builds, copy only requirements and install them
COPY . .

# Install requirements and ignore warnings for local installation
RUN pip install --no-cache-dir --user --no-warn-script-location -r requirements.txt

RUN pip install --no-cache-dir --user --no-warn-script-location .

# Second stage
FROM python:3.9-slim as app

# Bluetoothctl is required
RUN apt-get update && \
    apt-get install --no-install-recommends bluez -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*;

# Copy the local python packages
COPY --from=builder /root/.local /root/.local

# Copy run script
COPY ./docker_entrypoint.sh docker_entrypoint.sh
RUN chmod +x docker_entrypoint.sh

ENV PATH=/root/.local/bin:$PATH

CMD [ "./docker_entrypoint.sh" ]
