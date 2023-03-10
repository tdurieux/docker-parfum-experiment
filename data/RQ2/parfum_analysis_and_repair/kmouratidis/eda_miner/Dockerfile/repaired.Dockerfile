# our base image
FROM python:3.6

# Get the latest version of pip
RUN pip install --no-cache-dir --upgrade pip

# Get the necessary dependencies for pygraphviz
RUN apt-get update && apt-get install --no-install-recommends gcc libgraphviz-dev graphviz -y --fix-missing && rm -rf /var/lib/apt/lists/*;

# Copy this first and install the requirements
# so you don't have to reinstall them unless they change
COPY ./requirements.txt /usr/src/app/

# Install requirements
WORKDIR /usr/src/app/
RUN pip install --no-cache-dir -r requirements.txt

# copy the rest of the files required for the app to run
COPY ./ /usr/src/app/

# tell the port number the container should expose
EXPOSE 8000

# Change to project dir
WORKDIR /usr/src/app/EDA_miner

# Create a user database
RUN python initialize_project.py

CMD ["gunicorn", "wsgi:application"]
