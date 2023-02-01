# Start with 'gunns_unloaded' image.
FROM gunns_unloaded

# Clone GUNNS
WORKDIR /home
RUN git clone https://github.com/nasa/gunns.git

# Make the GUNNS compiled libs