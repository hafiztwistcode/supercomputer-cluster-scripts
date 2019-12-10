#!/bin/bash

IP=$1
HOST=$2
PASSWORD="+WtW1575+"

echo "Starting to initiate adding a node into the cluster"
echo The node ip is $IP
echo The node hostname is $HOST

echo "###### STARTINGGG.... #######"
echo "###### EDITING THE MASTER NODE.... #######"

echo "[1] Adding new IP and host into the /etc/hosts"
printf  "%s\n" "$IP slots=3 max-slots=3" >> ~/hpcg/hpcg-3.1_cuda9_ompi1.10.2_gcc485_sm_35_sm_50_sm_60_sm_70_ver_10_8_17/semua_nodes2
echo "[1] DONE"

# echo "[2] Adding new IP and host into the openmpi hostfile"
# echo $PASSWORD | printf "$IP\t$HOST\n"| sudo tee -a /etc/hosts
# echo "[2] DONE"

echo "###### DONE EDITING THE MASTER NODE.... #######"
echo "###### EDITING THE WORKING NODE.... #######"

#add passwordless ssh
echo "[1] Adding paswordless ssh"
sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no twistcode@$1 mkdir -p .ssh
cat /home/twistcode/.ssh/id_rsa.pub | sshpass -p $PASSWORD ssh -o StrictHostKeyChecking=no twistcode@$1 'cat >> .ssh/authorized_keys'
echo "[1] DONE"

#install mpi and nfs
echo "[2] Updating packages"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo apt update"
echo "[2] DONE"
echo "[3] Installing mpi"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo apt --assume-yes install openmpi-bin"
echo "[3] DONE"
echo "[4] Installing nfs common"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo apt --assume-yes install nfs-common"
echo "[4] DONE"

#create NFS
echo "[5] Creating nfs share"
echo $PASSWORD | ssh -tt twistcode@$IP "mkdir /home/twistcode/hpcg"
echo "[5] DONE"
echo "[6] adding into fstab"
echo $PASSWORD | ssh -tt twistcode@$IP " echo "10.0.0.1:/home/twistcode/hpcg           /home/twistcode/hpcg    nfs defaults,user,exec          0 0" | sudo tee -a /etc/fstab "
echo "[6] DONE"
echo "[7] mounting all"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo mount -a"
echo "[7] DONE"

#add all cuda and MPI library
echo "[8] Adding all Cuda and MPI library to the working node"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo cp -r ~/hpcg/cuda-9.0-lib/* /usr/local/cuda-10.0/lib64"
echo $PASSWORD | ssh -tt twistcode@$IP "sudo cp -r ~/hpcg/openmpi-lib/* /usr/lib/x86_64-linux-gnu/openmpi/lib"
echo "[8] DONE"

#copying bashrc
echo "[8] Copying master node bashrc"
ssh -tt twistcode@$IP "cp  ~/hpcg/.bashrc ~/.bashrc"
echo "[8] DONE"

echo "###### DONE EDITING THE WORKING NODE.... #######"
echo "###### FINISHED.... #######"








