# Docker and Kubernetes Homework

This pipeline pushes a Docker image to ttl.sh and then it is pulled from Target and K8S machines. In the case of k8s, it is handled by ansible for simplicity. First the existing pod and deploys are deleted, and then the new pod is created and deployed with two replicas.  
