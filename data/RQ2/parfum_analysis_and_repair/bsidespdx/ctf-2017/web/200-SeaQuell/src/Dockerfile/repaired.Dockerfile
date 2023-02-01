# Import Python runtime and set up working directory
FROM python:2.7-slim
WORKDIR /
RUN apt-get update && apt-get install --no-install-recommends -y sqlite3 && rm -rf /var/lib/apt/lists/*;
ADD seaquell* /
ADD *html /
ADD employees-only /employees-only

#just in case someone finds an additional exploit:
RUN ln -s /employees-only/flag /flag

EXPOSE 8000

# Run app.py when the container launches
CMD ["su","-s","/bin/sh","nobody","-c","python seaquell.py"]
