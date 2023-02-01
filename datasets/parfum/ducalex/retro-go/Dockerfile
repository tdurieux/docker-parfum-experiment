FROM espressif/idf:release-v4.1

WORKDIR /app

ADD . /app

# RUN pip install -r requirements.txt

# Apply patches
RUN cd /opt/esp/idf && \
	patch --ignore-whitespace -p1 -i "/app/tools/patches/panic-hook (esp-idf 4.0 and 4.1).diff" && \
	patch --ignore-whitespace -p1 -i "/app/tools/patches/sdcard-fix (esp-idf 4.0 and 4.1).diff"

# Build
RUN . /opt/esp/idf/export.sh && \
	python rg_tool.py --target=odroid-go release && \
	python rg_tool.py --target=mrgc-g32 release
