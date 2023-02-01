FROM python:2.7.15-stretch

# Install dns utils so we can run dig
RUN apt-get update && apt-get install dnsutils -y

# The run script is what actually runs our func tests
COPY run.sh /app/run.sh
RUN chmod a+x /app/run.sh

COPY run-tests.py /app/run-tests.py
RUN chmod a+x /app/run-tests.py

# Copy over the functional test directory, this must have been copied into the build context previous to this building!
ADD functional_test /app

# Install our func test requirements
RUN pip install --index-url https://pypi.python.org/simple/ -r /app/requirements.txt

# set the entry point for the container to start vinyl, specify the config resource
ENTRYPOINT ["/app/run.sh"]
