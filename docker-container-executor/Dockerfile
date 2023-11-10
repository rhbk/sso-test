FROM fedora:latest
MAINTAINER Keycloak QE <keycloak-qe@redhat.com>
ENV OC_VERSION=stable
ARG ARCH
ARG VERSION
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
      version=$VERSION

RUN dnf update -y && dnf install -y which python3 python3-pip rust cargo openssl-devel libffi-devel \
        sudo openssl ansible python-yaml

RUN pip install kubernetes

# Install OpenShift & Kubernetes CLI
RUN curl https://mirror.openshift.com/pub/openshift-v4/${ARCH}/clients/ocp/${OC_VERSION}/openshift-client-linux.tar.gz -o openshift-client-linux.tar.gz && \
    tar xzvf openshift-client-linux.tar.gz && \
    install -o root -g root -m 0755 oc /usr/local/bin/oc && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    rm -f openshift-client-linux.tar.gz oc kubectl README.md

RUN mkdir -p /tmp/tests/ansible-tests
WORKDIR /tmp/tests/ansible-tests

# Make Ansible happy with arbitrary UID/GID in OpenShift.
RUN chmod g=u /etc/passwd /etc/group \
  && chgrp -R 0 /tmp \
  && chmod -R g=u /tmp

COPY configs/keycloak-resource.yaml /tmp/tests/ansible-tests/configs/keycloak-resource.yaml
COPY roles/deploy_image/tasks/deploy_image.yml /tmp/tests/ansible-tests/roles/deploy_image/tasks/deploy_image.yml
COPY roles/deploy_image/tasks/deploy_image.yml /tmp/tests/ansible-tests/roles/deploy_image/tasks/main.yml
COPY vars/global.yml /tmp/tests/ansible-tests/vars/global.yml
COPY ansible.cfg /tmp/tests/ansible-tests/ansible.cfg
COPY test-ocp-ci-rhbk.yml /tmp/tests/ansible-tests/test-ocp-ci-rhbk.yml

ENTRYPOINT ["/bin/bash"]
