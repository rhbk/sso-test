FROM fedora:latest
MAINTAINER Keycloak QE <keycloak-qe@redhat.com>
ENV KUBECONFIG=/tmp/tests/ansible-tests/kubeconfig
ENV JUNIT_OUTPUT_DIR=/tmp/tests/ansible-tests/junit-results
# Labels consumed by Red Hat build service
LABEL com.redhat.component="interop-ocp-ci" \
      name="keycloakqe/interop-ocp-ci" \
      architecture=linux/$ARCH \
      io.k8s.display-name="RHBK OCP Image testing executor" \
      io.k8s.description="The RHBK OCP Image testing executor is intended to be the executor for ansible tests used during the Interop testing." \
      io.openshift.tags="rhbk,integration,interop" \
      maintainer="keycloak-qe@redhat.com" \
      vendor="Red Hat Single Sign-On product" \
      version="latest"

RUN dnf update -y && dnf install -y which python3 python3-pip rust cargo openssl-devel libffi-devel \
        sudo openssl ansible python-yaml

RUN pip install kubernetes

RUN mkdir -p /tmp/tests/ansible-tests
WORKDIR /tmp/tests/ansible-tests

# Make Ansible happy with arbitrary UID/GID in OpenShift.
RUN chmod g=u /etc/passwd /etc/group \
  && chgrp -R 0 /tmp \
  && chmod -R g=u /tmp

COPY . /tmp/tests/ansible-tests/

ENTRYPOINT ["/bin/bash"]
