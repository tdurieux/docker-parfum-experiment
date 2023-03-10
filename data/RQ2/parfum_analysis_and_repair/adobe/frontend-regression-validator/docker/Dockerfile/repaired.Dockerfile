FROM python:3.7-slim-buster

WORKDIR /fred

# Installing build dependencies
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get --no-install-recommends install -y curl unzip libnss3-dev libcups2-dev libasound2-dev libatk1.0-dev libatk-bridge2.0-dev libgtk-3-dev libpangocairo-1.0-0 python3-pip xorg && apt-get clean && rm -rf /var/lib/apt/lists/*;

# installs chromium and chromedriver 80.0.3987
RUN curl -f -o chromium.zip https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F722276%2Fchrome-linux.zip?alt=media && unzip chromium.zip && rm -f chromium.zip && \
    mv chrome-linux /usr/lib/chromium-browser
RUN curl -f -O https://chromedriver.storage.googleapis.com/80.0.3987.106/chromedriver_linux64.zip && unzip chromedriver_linux64.zip && rm -f chromedriver_linux64.zip && \
    mv chromedriver /usr/lib/chromium-browser/

COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

COPY fred/ .

# Extract the model files
RUN cd ml && cat model_files.bz2.parta* > model_files.bz2 && tar xjf model_files.bz2 && rm -f model_files.bz2*

CMD python3 run.py
EXPOSE 5000
