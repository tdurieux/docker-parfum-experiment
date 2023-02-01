# set base image (host OS)
FROM python:3.8

# set the working directory in the container
WORKDIR /code

# install google chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get -y update
RUN apt-get install --no-install-recommends -y google-chrome-stable && rm -rf /var/lib/apt/lists/*;

# install chromedriver
RUN apt-get install --no-install-recommends -yqq unzip && rm -rf /var/lib/apt/lists/*;
RUN wget -O /tmp/chromedriver.zip https://chromedriver.storage.googleapis.com/$( curl -f -sS chromedriver.storage.googleapis.com/LATEST_RELEASE_87.0.4280)/chromedriver_linux64.zip
RUN unzip /tmp/chromedriver.zip chromedriver -d ./

#Set up Environment variables
ENV DRIVER_PATH=/chromedriver

# copy the dependencies file to the working directory
COPY requirements.txt .

# install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# copy the content of the local directory to the working directory
COPY . .

# command to run on container start
CMD [ "python", "./main.py" ]