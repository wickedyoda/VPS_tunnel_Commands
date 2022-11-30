#Makes the update file and adds contents to it
echo "sudo apt-get update
sudo apt-get full-upgrade -y
sudo apt-get dist-upgrade -y
sudo apt-get autoremove -y
sudo apt-get clean -y
sudo apt-get purge -y" > update.sh

#change update file to excutable
sudo chmod +x ./update.sh

#reboot the system
sudo reboot

#install common ubuntu apps
sudo apt install software-properties-common

#For Ubuntu installs the following line is not needed.
#only run this for debian or if installing wireguard fails.
sudo add-apt-repository ppa:wireguard/wireguard

#Update your repos and local apt files
sudo apt update

#install wireguard
sudo apt install wireguard -y

#Generate public and private keys for client and server.
#Be sure to keep these safe and not share
(umask 077 && printf "[Interface]\nPrivateKey= " | sudo tee /etc/wireguard/wg0.conf > /dev/null)
wg genkey | sudo tee -a /etc/wireguard/wg0.conf | wg pubkey | sudo tee /etc/wireguard/publickey

#open /etc/wireguard/wg0.conf
sudo nano /etc/wireguard/wg0.conf

#Edit them to match the server and client side including adding the keys. 

#open /etc/systl.conf
sudo nano /etc/systl.conf

#Find and remove the # infront of the net.ipv4.ip_forward=1 entry and 
#net.ipv6.conf.all.forwarding=1 if you wish to use IPv6

#Apply the changes. 
sudo sysctl -p
sudo sysctl --system

#use the following commands to bring the tunnel up and verify you can ping systems from the other.
sudo systemctl start wg-quick@wg0
sudo systemctl enable wg-quick@wg0

