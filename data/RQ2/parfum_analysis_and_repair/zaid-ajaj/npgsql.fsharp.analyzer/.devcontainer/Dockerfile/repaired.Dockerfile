FROM fsharp:10.2.3-netcore

# Copy endpoint specific user settings into container to specify
# .NET Core should be used as the runtime.
COPY settings.vscode.json /root/.vscode-remote/data/Machine/settings.json

# Install git, process tools
RUN apt-get update && apt-get -y --no-install-recommends install git procps && rm -rf /var/lib/apt/lists/*;
