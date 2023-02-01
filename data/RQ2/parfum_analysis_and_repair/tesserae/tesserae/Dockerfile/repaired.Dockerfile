FROM perl:5.30

# Runp apt update so we can install PHP.
RUN apt update && apt install --no-install-recommends php -y && rm -rf /var/lib/apt/lists/*; # Install defalutl PHP (which is 7+).


# Create directory (volume).
RUN mkdir /app

# Set the default working directory.
WORKDIR /app

# Expose the port where PHP server is running.
EXPOSE 8000

# Entry point is the PHP built in server.
ENTRYPOINT ["php", "-S", "0.0.0.0:8000"]
