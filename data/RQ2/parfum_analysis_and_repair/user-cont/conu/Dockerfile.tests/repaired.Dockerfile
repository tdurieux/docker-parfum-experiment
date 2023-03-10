FROM docker.io/usercont/conu:dev

# a solution to set cgroup_manager to cgroupfs since we don't have
# systemd in the container where we run tests
RUN cp /usr/share/containers/libpod.conf /etc/containers/ \
    && sed -i '/cgroup_manager/ s/systemd/cgroupfs/' /etc/containers/libpod.conf \
    && sed -i '/^mountopt/ s/mountopt/# mountopt/' /etc/containers/storage.conf \
    && sed -i 's/^# events_logger.\+$/events_logger = "none"/' /etc/containers/libpod.conf \
    && printf "unqualified-search-registries = ['registry.fedoraproject.org', 'registry.access.redhat.com', 'registry.centos.org', 'docker.io']\n" > /etc/containers/registries.conf \
    && printf '[[registry]]\nprefix = "docker.io"\ninsecure = true\nlocation = "localhost:5000"\n' >> /etc/containers/registries.conf