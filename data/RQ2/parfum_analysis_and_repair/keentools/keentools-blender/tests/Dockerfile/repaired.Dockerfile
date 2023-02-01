FROM ubuntu
RUN apt-get update -y && apt-get install --no-install-recommends -y curl && apt-get install --no-install-recommends -y libgl1-mesa-dev libxi-dev libxrender-dev libssl1.1 libgomp1 xz-utils && rm -rf /var/lib/apt/lists/*;
RUN curl -f -L https://download.blender.org/release/Blender2.91/blender-2.91.0-linux64.tar.xz -o /home/blender.tar.xz
RUN tar -xf /home/blender.tar.xz -C /home && rm /home/blender.tar.xz
RUN /home/blender-2.91.0-linux64/2.91/python/bin/python3.7m -m ensurepip && /home/blender-2.91.0-linux64/2.91/python/bin/python3.7m -m pip install --upgrade pip && /home/blender-2.91.0-linux64/2.91/python/bin/python3.7m -m pip install teamcity-messages
