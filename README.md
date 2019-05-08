# Kubernetes Local Cluster Setup

## Description
This repository contains all the files needed to setup a local Kubernetes cluster with Vagrant and Virtualbox. Currently, the Vagrantfile is configured to read in a config file to build a Kubernetes cluster of any size that is configured. The repository contains 2 pre-configured types:

* **single** - A single development node. Once configured it will need to be untainted so jobs can run on it as it is a master Kubernetes node. The node will have 8 vCPUs and 8192MB of RAM.
* **cluster** - A Kubernetes cluster contained 4 nodes (1 master and 3 workers). Each node will have 2 vCPUs and 2048MB of RAM each.

More configurations can be easily added by adding additional YAML config files to the config directory.

## Pre-Requisities
In order to use these files, you will needed a few packages on the hosting system:

* **Virtualbox -** Virtualbox is needed to provide the virtual machine/networking layer. The host machine will need to have more then 8GB or RAM, the current configuarion of nodes will use this alone.
* **Vagrant -** Vagrant is needed to run the script that will configure the Virtual Machines. The Vagrantfile will create the nodes, configure the OS for Kubernetes, and install the base packages for Kubernetes.
* **Kubectl -** Kubectl will be needed to manage the cluster from the host system once it is configured.

## Setting Up A Cluster
### Starting the Virtual Machines
To setup a cluster, the first step is to configure the virtual machines. Change directorys to the root of the repository path, and enter the following:

```bash
vagrant --config=<CONFIG> up
```

The CONFIG option should be the name of the config file to use from the config path (e.g. single or cluster by default). Vagrant will being by downloading an image from the Internet (bento/ubuntu16.04) and use this image to start the machines. The primary machine will be named "master". For the *cluster* configuration, the additional machines are named "worker1", "worker2", and "worker3". Once the bento image is downloaded, any future creations will be much faster. It usually takes around 7 minutes for run up a full Kubernetes cluster configuration.
Vagrant will also execute an ansible provisioner and use the scripts/setup_node.yml playbook to configure the machine operating system for the kubernetes environment.

### Setting up the Master Node
Once vagrant is complete, it is time to log in and setup the master. This can be done with the regular kubeadm command, however, a script is provided to make things easier. To access master console:

```bash
vagrant ssh master
```

This will give you an ssh prompt to the master virtual machine. Once you have the prompt, enter the command:

```bash
sudo /vagrant/scripts/setup_master.sh
```

The setup_master script will configure the kubernetes master, but also create and copy a node join token to a file for later execution, and copy the kubernetes config file for later also. Once the script is complete, type:

```bash
exit
```

To leave the session.

## Setup The Host For Kubernetes
Once back in the console, perform the following command to copy the kubernetes config file:

```bash
cp output/kube.config ~/.kube/config
```

If this is the first time using Kubernetes on the host, the ~/.kube path may need to be created first. When the file is in place, the kubectl command should be able to contact the local kubernetes cluster. To test:

```bash
kubectl cluster-info
```

### Untaint The Master Node (Single Node Configurations Only)
If there is only one Kubernetes Node configured in the cluster, it will need to have the 'master' taint removed so worker jobs can share the node with the master jobs. A script is provided to do this:

```bash
./scripts/untaint_master.sh
```

Once executed, the master taint is removed and the single node will be able to process regular jobs.

### Deploy the Kubernetes CNI
Once the master is successfully deployed, and the host is configured the communicate with it, the CNI can be configured. This is the final step to bring the master node fully online. The repository contains a command to install the Weave Net CNI, this can be deployed the following command on the host:

```bash
./scripts/setup_weave_net.sh
```

Once executed, the latest Weave Net file will be applied, and the required containers will be executed on the cluster. By issuing:

```bash
kubectl get nodes
```

It is possible to see the current state of the master. It will start with 'NotReady' and move to 'Ready' when the Weave Net services have started and the CoreDNS services successfully start.

### Joining The Other Nodes (Cluster Mode)
Once the master is setup, the hard work is done. To add the nodes, login to each of their consoles:

```bash
vagrant ssh worker1
```

And execute the join_cluster.sh script which was generated when the master was created:

```bash
sudo /vagrant/output/join_cluster.sh
```

The virtual machine will configure itself and be joined to the cluster. Exit the console as before:

```bash
exit
```
