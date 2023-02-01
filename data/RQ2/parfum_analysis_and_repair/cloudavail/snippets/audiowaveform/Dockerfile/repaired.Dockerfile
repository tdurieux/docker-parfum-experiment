FROM ubuntu:latest

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    yes | add-apt-repository ppa:chris-needham/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends audiowaveform -y && rm -rf /var/lib/apt/lists/*;
