FROM node:11-slim

# Copy app
COPY . /code

# Define directories
WORKDIR /code

# install dependencies
RUN npm install && npm cache clean --force;
RUN apt-get update && apt-get install --no-install-recommends -y nginx && rm -rf /var/lib/apt/lists/*;

#make scripts executable
RUN chmod +x generate_static_files.sh
RUN chmod +x nginx_setup.sh

# Expose port
EXPOSE 80

CMD ["sh", "-c", "./generate_static_files.sh && ./nginx_setup.sh"]
