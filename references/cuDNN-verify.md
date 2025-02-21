Verifying the Install on Linux
To verify that cuDNN is installed and is running properly, compile the mnistCUDNN sample located in the /usr/src/cudnn_samples_v9 directory in the Debian file.

Install the cuDNN samples.

sudo apt-get -y install libcudnn9-samples
or

sudo dnf -y install libcudnn9-samples
Go to the writable path.

cd $HOME/cudnn_samples_v9/mnistCUDNN
Compile the mnistCUDNN sample.

make clean && make
Run the mnistCUDNN sample.

./mnistCUDNN
If cuDNN is properly installed and running on your Linux system, you will see a message similar to the following:

Test passed!