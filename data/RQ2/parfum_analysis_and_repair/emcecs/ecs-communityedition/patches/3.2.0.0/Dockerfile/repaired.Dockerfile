# Fixes to the default 3.2.0.0 reduced image.

# Build on object-reduced image (GA release)
FROM emcvipr/object:3.2.0.0-101423.d3b297f-reduced

# Increase memory for transformsvc
RUN sed -i s/Xmx128m/Xmx512m/ /opt/storageos/bin/transformsvc

# Set memory for objcontrolsvc
RUN sed -i s/Xmx96m/Xmx256m/ /opt/storageos/bin/objcontrolsvc

# Fix disk partitioning script
RUN sed -i '/VMware/ s/$/ \&\& [ ! -e \/data\/is_community_edition ]/' /opt/storageos/bin/storageserver-partition-config.sh

RUN /usr/bin/chmod +x /opt/storageos/bin/storageserver-partition-config.sh

# Set VNest useSeperateThreadPools to True
RUN f=/opt/storageos/conf/vnest-common-conf.xml; grep -q "object.UseSeparateThreadPools" $f || sed -i '/properties id="serviceProperties"/a \ \ \ \ \ \ \ \ <prop key="object.UseSeparateThreadPools">true</prop>' $f

# Set georeceiver's initialBufferNumOnHeap to something smaller for CE
RUN f=/opt/storageos/conf/georeceiver-conf.xml; grep -q 'name="initialBufferNumOnHeap" value="5"' $f ||  sed -i 's/name="initialBufferNumOnHeap" value="60"/name="initialBufferNumOnHeap" value="5"/' $f

RUN f=/opt/storageos/conf/georeceiver-conf.xml; grep -q '<prop key="object.InitialBufferNumOnHeap">10</prop>' $f || sed -i 's#<prop key="object.InitialBufferNumOnHeap">80</prop>#<prop key="object.InitialBufferNumOnHeap">10</prop>#g' $f

# Configure CM Object properties: Disable minimum storage device count
RUN f=/opt/storageos/conf/cm.object.properties; grep -q 'MustHaveEnoughResources=false' $f ||  sed -i 's/MustHaveEnoughResources=true/MustHaveEnoughResources=false/' $f

# Allow allocation of different blocks of a chunk to be stored on the same partition