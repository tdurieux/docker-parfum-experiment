FROM codercom/enterprise-multieditor:centos

# Run everything as root
USER root

# Install clion.
RUN mkdir -p /opt/clion
RUN curl -f -L "https://download.jetbrains.com/product?code=CL&latest&distribution=linux" | tar -C /opt/clion --strip-components 1 -xzvf -

# Add a binary to the PATH that points to the clion startup script.
RUN ln -s /opt/clion/bin/clion.sh /usr/bin/clion

# Set back to coder user
USER coder
