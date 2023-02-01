FROM microsoft/dotnet:1.0.0-core

# Set the Working Directory
WORKDIR /app

# Configure the listening port to 80
ENV ASPNETCORE_URLS http://*:80
EXPOSE 80

# Copy the app
COPY /app /app

# Start the app
ENTRYPOINT dotnet StatelessValuesMicroservice.dll
