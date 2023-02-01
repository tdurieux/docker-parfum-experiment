FROM python:3.8-slim

RUN apt-get update && apt-get install --no-install-recommends -y curl && rm -rf /var/lib/apt/lists/*;

# copy normal scripts
COPY normal.py /home/normal.py
# add wiki data to image
COPY filesplits/ /home/filesplits/

# run the normal behaviour
ENTRYPOINT ["python3", "-u", "/home/normal.py"]
CMD []