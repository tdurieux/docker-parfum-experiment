# Note: use this image as a base if you are dependent upon cryptography
# See teams image for an example.
FROM demisto/python3:3.10.4.28442

COPY requirements.txt .

# Crypto  needs the latest pip