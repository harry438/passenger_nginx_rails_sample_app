# passenger_nginx_rails_sample_app
samples app made to demonstrate deployment of Rail 4 app with Phusion Passenger and Nginx

## Technology stack
- Ruby 2.1.2, Rails 4.1, RVM, Phusion Passenger, Nginx, Ubuntu 14.04, MySql, MongoDB, GitHub, AWS(EC2, RDS, ElasticIP)

## Launch EC2 instance
- Reference - https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/aws/nginx/oss/launch_server.html

## Map Elastic IP with EC2 instance
- Go to AWS console and click on "Elastic IPs" in left panel in EC2 section 
- Click on "Allocate New Address" at the top of the page
- Click on "Yes, Allocate"

- Select newly issued Elastic IP and click on "Actions"
- Select option "Associate Address"

- Type Instance-Id or Name of the instance in Instance textbox
- Select relevant Instance from dropdown

## Create alias to SSH EC2 instance in your local machine

- Open bash_profile file 
  - $ vi ~/.bash_profile 
- Add below line in bash_profile file
  - $ alias ssh-app-server1="ssh -i ~/.ssh/key-pair.pem ubuntu@1.1.1.1" # Replace with your server ip / Elastic IP / public DNS
- Note: Ubuntu creates a default user “ubuntu” & 
- Save 
  - $ :wq
- Refresh file 
  - $ source ~/.bash_profile 
- Try Alias 
  - $ ssh-app-server1 

## Prepare system

- Connect to server 
  - $ ssh-app-server1 
- Update system
  - $ sudo apt-get update
  - $ sudo apt-get install -y curl gnupg build-essential

## Install RVM

- Rub below commands 
  - $ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  - $ curl -sSL https://get.rvm.io | sudo bash -s stable
  - $ sudo usermod -a -G rvm `whoami`

  - Note: path where RVM gets installed - /usr/local/rvm/ 

- set rvmsudo_secure_path=1
  - $ if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
- Re-login to server to activate RVM, else RVM does not work.

## Install Ruby 
- We are going to install and use version 2.1.2. You can choose version you want to install
  - $ rvm install ruby 2.1.2
  - $ rvm --default use ruby 2.1.2 (set it as a default ruby version)

## Install Bundler
- gem install bundler --no-rdoc --no-ri

## Install Node.js
- Node.js is must for Rails apps
- Run below commands to install 
  - $ sudo apt-get install -y nodejs &&
  - $ sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
- Verify installation by checking version. Run below command 
  - $ node -v

## Install Passenger + Nginx 

- Install Phusion Passenger’s PGP key and add HTTPS support for APT
  - $ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
  - $ sudo apt-get install -y apt-transport-https ca-certificates
  - $ sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
  - $ sudo apt-get update
  
- Install Passenger + Nginx
  - $ sudo apt-get install -y nginx-extras passenger
- Enable Passenger Nginx module and Restart Nginx
  - Edit /etc/nginx/nginx.conf 
    - $ sudo vi /etc/nginx/nginx.conf 
  - Uncomment line “ # include /etc/nginx/passenger.conf; ” by removing “#” and Save file
    - include /etc/nginx/passenger.conf;

- Restart Nginx
  - $ sudo service nginx restart
- Validate installation
  - $ sudo /usr/bin/passenger-config validate-install

- Finally, check whether Nginx has started the Passenger core processes
  - $ sudo /usr/sbin/passenger-memory-stats

- Note: You should see both Nginx processing & Passenger processes. Please refer to the passenger troubleshooting guide (https://www.phusionpassenger.com/library/admin/nginx/troubleshooting/) if result does not look like shown below 


- Check for updates of newly installed Passenger and Nginx packages 
  - $ sudo apt-get update
  - $ sudo apt-get upgrade

Congratulations! Your server is now ready to deploy Rails application.

## Install and Setup Git

- Run below command to install 
  - $ sudo apt-get install git
- Setup git
  - $ git config --global user.name "Your Name"
  - $ git config --global user.email "youremail@domain.com"
- Verify configurations
  - $ git config --list
- Generate SSH key to access your GitHub account from the server 
  - Refer - https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
- Add SSH key to your GitHub account
  - Refer - https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
- Make SSH key accessible to username created as per above
  - $ sudo sh -c "cat $HOME/.ssh/id_rsa >> ~username/.ssh/id_rsa"
  - $ sudo sh -c "cat $HOME/.ssh/id_rsa.pub >> ~username/.ssh/id_rsa.pub”

## Create a new user for your app

- Replace “Ubuntu” adminuser with new user with admin privileges 
- Run below command to create a new user
  - $ sudo adduser username
- Make SSH key of ubuntu adminuser accessible to username
  - $ sudo mkdir -p ~username/.ssh
  - $ touch $HOME/.ssh/authorized_keys
  - $ sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~username/.ssh/authorized_keys"
  - $ sudo chown -R username: ~username/.ssh
  - $ sudo chmod 700 ~username/.ssh
  - $ sudo sh -c "chmod 600 ~username/.ssh/*"
 
  

