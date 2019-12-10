#IPS=(10.0.0.60   10.0.0.62   10.0.0.63   10.0.0.64   10.0.0.65   10.0.0.66   10.0.0.67   10.0.0.68   10.0.0.69   10.0.0.70   10.0.0.72   10.0.0.74   10.0.0.80   10.0.0.75   10.0.0.76   10.0.0.77   10.0.0.78   10.0.0.79)
# IPS=(10.0.0.5    10.0.0.6    10.0.0.7    10.0.0.9    10.0.0.10   10.0.0.12   10.0.0.15   10.0.0.16   10.0.0.17   10.0.0.18   10.0.0.19   10.0.0.20   10.0.0.21   10.0.0.22   10.0.0.23   10.0.0.24   10.0.0.25   10.0.0.28   10.0.0.29   10.0.0.30   10.0.0.31   10.0.0.32   10.0.0.33   10.0.0.34   10.0.0.35   10.0.0.36   10.0.0.37   10.0.0.38   10.0.0.39   10.0.0.40   10.0.0.41   10.0.0.42   10.0.0.43   10.0.0.44   10.0.0.45   10.0.0.46   10.0.0.47   10.0.0.48   10.0.0.49   10.0.0.50   10.0.0.51   10.0.0.52   10.0.0.53   10.0.0.55   10.0.0.56   10.0.0.57   10.0.0.58)
IPS=(10.0.0.15 )
PASSWORD="+WtW1575+"

for i in "${!IPS[@]}"
do
   
   # do whatever on $i
    echo "Starting to initiate adding a node into the cluster"
    echo The node ip is ${IPS[i]}

    echo "###### EDITING NODE ${IPS[i]} for linpack.. #######"

    echo "[1] adding linpack into fstab"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} "sudo mkdir /home/twistcode/linpack"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} " echo "10.0.0.1:/home/twistcode/linpack           /home/twistcode/linpack    nfs defaults,user,exec          0 0" | sudo tee -a /etc/fstab "
    echo "[1] DONE"
    echo "[2] mounting all"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} "sudo mount -a"
    echo "[2] DONE"


    echo "[3] Adding all Cuda and MPI library to the working node"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} "sudo cp -r ~/linpack/cuda-9.1-lib/* /usr/local/cuda-10.0/lib64"
    echo "[3] DONE"

    echo "[4] Adding intel MKL library"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} "sudo mkdir /opt/intel"
    echo $PASSWORD | ssh -tt twistcode@${IPS[i]} "sudo cp -r ~/linpack/intel/* /opt/intel" 
    echo "[4] DONE"

    echo "###### FINISH EDITING NODE ${IPS[i]} for linpack.. #######"
done


