FROM python:3.6.9

# Update
#RUN apk add --update python3 py-pip3

# Copy Python Sources
COPY Backend /src/backend
WORKDIR /src/backend/

# Copy Konfiguration File
#ADD config.yml .
#ADD requirements.txt .

# Install app dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Expose Port
EXPOSE 8080

# Run Python-Application
CMD ["python", "-u", "/src/backend/"]
