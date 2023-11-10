# Image for interoperability testing rhsso on openshift ci 

In order to verify that RHSSO is working as expected, ansible playbook is used to deploy RHSSO using already installed RHSSO operator under the provided namespace on the openshift cluster.

Kubeconfig is required to get access to the cluster. 

Automation can be executed as per example:
```
podman run --rm -v /local/tmp/kubeconfig:/tmp/kubeconfig -e OCP_PROJECT_NAME="namespace" -e OCP_API_URL="https://example.com" -it {{IMAGE_ID}} -c 'ansible-playbook -v /tmp/tests/ansible-tests/test-ocp-ci-rhbk.yml --extra-vars "ocp_project_name=${OCP_PROJECT_NAME}"'
```

