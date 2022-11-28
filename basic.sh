#!/bin/bash -x

echo "Starting Script"
e=0;
#install package
sudo apt-get -qq update -y || { echo "command: apt update FAILED"; e=1; }
sudo apt-get -qq install curl -y || { echo"command: apt install curl FAILED"; e=1; }

# curl access
curl https://github.com/oneconvergence/dkube-examples/blob/tensorflow/README.md > curl-output.txt;rm curl-output.txt || { echo "command: curl https://github.com/oneconvergence/dkube-examples/blob/tensorflow/README.md FAILED"; e=1; }

#Cloning git repository
[[ -d "./dockyard-resources" ]]  &&  sudo rm -rf ./dockyard-resources
git clone https://github.com/oneconvergence/dkube-examples.git || { echo "command: git clone https://github.com/oneconvergence/dkube-examples.git FAILED"; e=1; }

#aws s3 access 
aws sts get-caller-identity || { echo "command: aws sts get-caller-identity FAILED"; e=1; }

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate . || { echo "command: aws s3 cp to current dir FAILED"; e=1; }

aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default && { echo "command: aws s3 cp s3://altos-oneconvergence-tfstate/root.tfstate /home/default PASSED UNEXPECTED" && sudo rm -rf /home/default/root.tf; e=1; }


[[ ${e} == 0 ]] && echo "SCRIPT RAN SUCESSFULLY";
