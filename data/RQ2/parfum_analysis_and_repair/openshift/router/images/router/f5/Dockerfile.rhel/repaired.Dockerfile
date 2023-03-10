FROM registry.svc.ci.openshift.org/ocp/4.0:base-router
RUN ln -s /usr/bin/openshift-router /usr/bin/openshift-f5-router
LABEL io.k8s.display-name="OpenShift F5 Router" \
      io.k8s.description="This is a component of OpenShift and programs a BigIP F5 router to expose ingress to services within the cluster." \
      io.openshift.tags="openshift,router,f5"
ENTRYPOINT ["/usr/bin/openshift-f5-router"]