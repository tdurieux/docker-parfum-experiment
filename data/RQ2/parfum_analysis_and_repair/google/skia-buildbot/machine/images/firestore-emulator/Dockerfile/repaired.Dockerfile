FROM gcr.io/google.com/cloudsdktool/cloud-sdk:latest

RUN apt-get install -y --no-install-recommends google-cloud-sdk-firestore-emulator && rm -rf /var/lib/apt/lists/*;