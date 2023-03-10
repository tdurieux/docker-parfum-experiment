FROM public.ecr.aws/lambda/nodejs:10.2020.12.01.12
ARG FUNCTION_DIR="/var/task"

# Install tar and xz
RUN yum install tar xz unzip -y && rm -rf /var/cache/yum

# Install awscli
RUN curl -f "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" -s
RUN unzip -q awscliv2.zip
RUN ./aws/install

# Install ffmpeg
RUN curl -f https://johnvansickle.com/ffmpeg/releases/ffmpeg-release-amd64-static.tar.xz -o ffmpeg.tar.xz -s
RUN tar -xf ffmpeg.tar.xz && rm ffmpeg.tar.xz
RUN mv ffmpeg-4.3.1-amd64-static/ffmpeg /usr/bin

# Create function directory
RUN mkdir -p ${FUNCTION_DIR}

# Copy handler function and package.json
COPY index.js ${FUNCTION_DIR}

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "index.handler" ]
