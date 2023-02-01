FROM phocean/msf

COPY "entrypoint.sh" .

RUN apt-get update && \
  apt-get install --no-install-recommends -y \
					git \
					python-dev \
					python-pip \
					apache2 && rm -rf /var/lib/apt/lists/*;

RUN chmod +x entrypoint.sh && \
	git clone https://github.com/NullArray/AutoSploit.git && \
	pip install --no-cache-dir -r AutoSploit/requirements.txt

EXPOSE 4444
CMD [ "./entrypoint.sh" ]
