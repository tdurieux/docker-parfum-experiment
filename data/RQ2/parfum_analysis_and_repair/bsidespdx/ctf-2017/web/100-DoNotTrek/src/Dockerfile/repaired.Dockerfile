# Import Python runtime and set up working directory
FROM python:2.7-slim
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends -y python-pip && rm -rf /var/lib/apt/lists/*;
RUN pip install --no-cache-dir flask
ADD dnt.py /dnt.py
ADD static /static
ADD templates /templates
ADD flag /flag

EXPOSE 5000

# Run app.py when the container launches
CMD ["su","-s","/bin/sh","nobody","-c","python dnt.py"]
