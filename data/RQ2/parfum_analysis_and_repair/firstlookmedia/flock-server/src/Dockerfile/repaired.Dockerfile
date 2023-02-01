FROM python:3.8-buster

# Install keybase
RUN \
	apt-get update && apt-get install --no-install-recommends -y fuse libappindicator1 libgconf-2-4 psmisc lsof libasound2 libnss3 libxtst6 libgtk-3-0 \
	# Get and verify Keybase.io's code signing key
	&& curl -f https://keybase.io/docs/server_security/code_signing_key.asc | gpg --batch --import \
	&& gpg --batch --fingerprint 222B85B0F90BE2D24CFEB93F47484E50656D16C7 \
	# Get, verify and install client package
	&& curl -f -O https://prerelease.keybase.io/keybase_amd64.deb.sig \
	&& curl -f -O https://prerelease.keybase.io/keybase_amd64.deb \
	&& gpg --batch --verify keybase_amd64.deb.sig keybase_amd64.deb \
	&& dpkg -i keybase_amd64.deb \
	&& apt-get install -f -y \
	# Cleanup
	&& rm -r /var/lib/apt/lists/* \
	&& rm keybase_amd64.deb*

# Install pipenv
RUN pip install --no-cache-dir pipenv

# Switch to unprivileged user
RUN useradd -ms /bin/bash user
USER user:user

WORKDIR /app
COPY Pipfile .
COPY Pipfile.lock .


# Install python dependencies
RUN pipenv --python /usr/local/bin/python install --dev

# Copy code
COPY . .

EXPOSE 5000
ENV FLASK_APP flock_server

CMD ["pipenv", "run", "python", "-u", "app.py"]
