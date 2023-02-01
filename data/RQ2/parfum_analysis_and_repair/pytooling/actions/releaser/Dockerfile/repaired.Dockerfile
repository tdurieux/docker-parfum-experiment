FROM python:3.9-slim-bullseye
COPY releaser.py /releaser.py
RUN pip install --no-cache-dir PyGithub --progress-bar off \
  && apt update -qq \
  && apt install --no-install-recommends -y curl \
  && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
     dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
     tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  && apt update -qq \
  && apt install --no-install-recommends -y gh && rm -rf /var/lib/apt/lists/*;
CMD ["/releaser.py"]
