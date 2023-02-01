FROM nginx
# Update the sources list
RUN apt-get update && apt-get install --no-install-recommends -y tar git curl nano wget dialog net-tools build-essential && rm -rf /var/lib/apt/lists/*; # Install basic applications

