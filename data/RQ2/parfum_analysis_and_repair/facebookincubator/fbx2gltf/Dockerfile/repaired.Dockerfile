FROM ubuntu:16.04

RUN apt-get update && \
    apt-get install --no-install-recommends -y software-properties-common && \
    add-apt-repository ppa:jonathonf/python-3.6 && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update && \
    apt-get install --no-install-recommends -y python3.6 curl build-essential cmake libxml2-dev zlib1g-dev git && \
    curl -f https://bootstrap.pypa.io/get-pip.py -o get-pip.py && python3 get-pip.py && \
    pip install --no-cache-dir conan && \
    conan remote add bincrafters https://api.bintray.com/conan/bincrafters/public-conan && rm -rf /var/lib/apt/lists/*;

# Install FBX SDK
RUN mkdir -p /fbx2gltf/sdk/Linux/2019.2 && \
    curl -f -L https://www.autodesk.com/content/dam/autodesk/www/adn/fbx/20192/fbx20192_fbxsdk_linux.tar.gz -o fbx20192_fbxsdk_linux.tar.gz && \
    tar -xvf fbx20192_fbxsdk_linux.tar.gz && \
    echo "yes\nn" | ./fbx20192_fbxsdk_linux /fbx2gltf/sdk/Linux/2019.2 && \
    rm -rf /fbxsdktemp && rm fbx20192_fbxsdk_linux.tar.gz

COPY . /fbx2gltf

WORKDIR /fbx2gltf

# Build and install
RUN conan install . -i docker-build -s build_type=Release -s compiler=gcc -s compiler.version=5 -s compiler.libcxx=libstdc++11 && \
    conan build -bf docker-build . && \
    cp docker-build/FBX2glTF /usr/bin && \
    cd / && \
    rm -rf /fbx2gltf /root/.conan
