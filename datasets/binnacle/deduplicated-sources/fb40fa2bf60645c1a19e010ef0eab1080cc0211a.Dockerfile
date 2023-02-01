FROM microsoft/dotnet:1.0.0-core

# Set the Working Directory
WORKDIR /app

# Configure the listening port to 80
ENV ASPNETCORE_URLS http://*:80
EXPOSE 80

# Copy the Debugger
COPY /clrdbg /clrdbg
RUN chmod 700 -R /clrdbg

# Copy the app
COPY /app /app

# If we are launching through a remote debugger wait for it, otherwise start the app
ENTRYPOINT ["/bin/bash", "-c", "if [ \"$REMOTE_DEBUGGING\" -eq 0 ]; then dotnet StatefulValuesMicroservice.dll; else sleep infinity; fi"]
