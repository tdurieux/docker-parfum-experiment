FROM daqf/aardvark:latest

# Get dependencies
RUN $AG update && $AG install curl ncrack medusa nmap git

COPY subset/security/password .

# Run the test
CMD ["./test_password"]