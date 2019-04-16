# Create a Cloud Server
- Sign up for a github student pack for free digital ocean credit!
- Create a digital ocean account with this same email
- Create a 'droplet', or computer running in the 'cloud'
- The $5/mo option is enough for us, though calculations may be a bit slow.
- For this, we'll install Ubuntu 16.04. 
- Give your server a nice name
- Then, an email will be sent to whatever email you used to sign up with with your password.
- Go to your Digital Ocean dashboard to get your ip address

## Initial Server Setup

Follow [this handy guide](uhttps://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu-18-04) to setup your server. 

##
Once you have that all setup, login with your username and ip address as above.
Go to your terminal. In the case of Windows, [use PuTTY](https://www.putty.org/). After you download it, open a new connection. It's pretty self explanatory. Make sure to use a 'SSH' connection. [SSH](https://www.ssh.com/ssh/protocol/) is a secure shell. It's a way to securely give a remote computer commands via the command line. 

After you have input your username (root) and your ip address, open your connection. If you are on Mac or Linux, type:
```
sudo ssh username@ip.add.re.sss
```

It will then prompt you to enter the email sent to you in the password (and possibly your local administrator password).  Congratualations. You are now using a remote server. 

## 

I followed [this guide](https://www.r-bloggers.com/how-to-install-r-ubuntu-16-04-xenial/).  

First, we added the repository to our list of sources. We could simply download the source code, but this allows the operating system to keep it updated for us.

```
sudo echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | sudo tee -a /etc/apt/sources.list
```
These cryptographically verify the software. Enter each line one at a time.
```
gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9
gpg -a --export E084DAB9 | sudo apt-key add -
```
Then we install base R. The first one updates the package lists in your repositories, fetching referencs to the stuff that you install in line 2.
```
sudo apt-get update
sudo apt-get install r-base r-base-dev
```
We do similar things for Rstudio. We're installing it directly from the rstudio website instead of the Ubuntu software center because it is updated more frequently via this method. Base R does not change often and can safely be fetched from the software center as above.
```
sudo apt-getinstall gdebi-core
wget https://download1.rstudio.org/rstudio-1.0.143-amd64.deb 
sudo gdebi -n rstudio-1.0.143-amd64.deb
rm rstudio-1.0.143-amd64.deb
```
## Install Git

## Install Docker

## Openwrt Docker x86
```
docker import http://downloads.openwrt.org/attitude_adjustment/12.09/x86/generic/ name_your_container
```


