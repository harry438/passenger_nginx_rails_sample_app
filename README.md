# passenger_nginx_rails_sample_app
Samples app to demonstrate deployment of Rail 4 app on AWS with Phusion Passenger and Nginx

## Technology stack
- AWS(EC2, RDS, ElasticIP, AMI), Ruby 2.1.2, Rails 4.1, RVM, Phusion Passenger, Nginx, Ubuntu 14.04, MySQL, GitHub

## Configure **Staging** environment in your application
- Update *database.yml*
  - Add section **staging**
  - We’ll update it with valid details later in this tutorial
- Add new environment file */config/environments/staging.rb* and copy+paste content of “*/environments/production.rb*” file for now
- Commit and push changes in git repository

## Launch EC2 instance
- [Click here](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/aws/nginx/oss/launch_server.html)

## Map Elastic IP with EC2 instance
- Go to AWS console and click on **Elastic IPs** in left panel in EC2 section 
- Click on "*Allocate New Address*" at the top of the page
- Click on "*Yes, Allocate*"

- Select newly issued Elastic IP and click on "*Actions*"
- Select option "*Associate Address*"

- Type **Instance-Id** or **Name of the instance** in Instance textbox
- Select relevant Instance from dropdown

## Create alias to SSH EC2 instance in your local machine

- Open *bash_profile* file 
```shell
$ vi ~/.bash_profile 
```
- Add below line in bash_profile file
```shell
$ alias ssh-app-server1="ssh -i ~/.ssh/key-pair.pem ubuntu@1.1.1.1" # Replace with your server ip / Elastic IP / public DNS
```
- **Note:** Ubuntu creates a default user “ubuntu” & 
- Save 
```shell
$ :wq
```
- Refresh file 
```shell
$ source ~/.bash_profile 
```
- Try Alias 
```shell
$ ssh-app-server1 
```
## Launch AWS RDS instance for MySQL database

- Go to AWS **RDS** section 
- Click on “*Get started now*”
- Select engine “*MySQL*”
- Select “*Dev/Test*” option
  - **Note:** For testing / learning purpose, select this option as it launches RDS instance with  Single availability zone.
  - For production environment, prefer Multi-AZ (Availability Zone) option

- Select DB instance class as **db.t2.micro**
- Select Multi-AZ Deployment as **No**

- Give valid inputs under “*Setting*” section for 
  - DB Instance Identifier, Username, Password
- Click on “*Next Step*”

- Select “*VPC Security Group(s)*” as **default** / **launch-wizard-1**
- Click on “*Launch*”

- Click on “**View DB Instance**”

- Modify security group
  - Select the RDS Instance
  - Click on details icon 
  - Click on link of “*Security Groups*” value as selected in configuration wizard

- Add new Rule
  - Select security group
  - Click on tab **Inbound**
  - Click on “*Edit*”
  - A popup opens 
    - Click on “*Add Rule*”
    - Select option **MYSQL/Aurora** from Type dropdown
    - Select option “*Anywhere*” from Source dropdown
      - **Note:** It’s not advisable to allow Source as Anywhere for Production environment.
    - Click on “Save”

## Update *database.yml* (For Staging)
- Copy “*Endpoint*” and add it as a host 
- Update root user credentials (username & password) as mentioned while configuring instance

## Prepare system

- Connect to server 
```shell
$ ssh-app-server1 
```
- Update system
```shell
$ sudo apt-get update
$ sudo apt-get install -y curl gnupg build-essential
```

## Install RVM

- Rub below commands 
```shell
$ gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
$ curl -sSL https://get.rvm.io | sudo bash -s stable
$ sudo usermod -a -G rvm `whoami`
```
  - **Note:** path where RVM gets installed - */usr/local/rvm/*

- set *rvmsudo_secure_path=1*
```shell
$ if sudo grep -q secure_path /etc/sudoers; then sudo sh -c "echo export rvmsudo_secure_path=1 >> /etc/profile.d/rvm_secure_path.sh" && echo Environment variable installed; fi
```
- Re-login to server to activate RVM, else RVM does not work.

## Install Ruby 
- We are going to install and use version 2.1.2. You can choose version you want to install
```shell
$ rvm install ruby 2.1.2
$ rvm --default use ruby 2.1.2 (set it as a default ruby version)
```
## Install Bundler
```ruby
$ gem install bundler --no-rdoc --no-ri
```
## Install Node.js
- Node.js is must for Rails apps
- Run below commands to install 
```shell
$ sudo apt-get install -y nodejs &&
$ sudo ln -sf /usr/bin/nodejs /usr/local/bin/node
```
- Verify installation by checking version. Run below command 
```shell
$ node -v
```
## Install Passenger + Nginx 

- Install Phusion Passenger’s PGP key and add HTTPS support for APT
```shell
$ sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
$ sudo apt-get install -y apt-transport-https ca-certificates
$ sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
$ sudo apt-get update
```  
- Install Passenger + Nginx
```shell
$ sudo apt-get install -y nginx-extras passenger
```
- Enable Passenger Nginx module and Restart Nginx
  - Edit */etc/nginx/nginx.conf*
```shell
$ sudo vi /etc/nginx/nginx.conf 
```
  - Uncomment line “*# include /etc/nginx/passenger.conf;*” by removing “#” and **Save** file
```shell
include /etc/nginx/passenger.conf;
```
- Restart Nginx
```shell
$ sudo service nginx restart
```
- Validate installation
```shell
$ sudo /usr/bin/passenger-config validate-install
```
- Finally, check whether Nginx has started the Passenger core processes
```shell
$ sudo /usr/sbin/passenger-memory-stats
```
- **Note:** You should see both Nginx processing & Passenger processes. Please refer to the passenger [troubleshooting guide](https://www.phusionpassenger.com/library/admin/nginx/troubleshooting/) if result does not look like shown below 


- Check for updates of newly installed Passenger and Nginx packages 
```shell
$ sudo apt-get update
$ sudo apt-get upgrade
```
Congratulations! Your server is now ready to deploy Rails application.

## Create a new user for your app

- Replace “Ubuntu” adminuser with new user with admin privileges 
- Run below command to create a new user
```shell
$ sudo adduser username
```
- Make SSH key of ubuntu adminuser accessible to username
```shell
$ sudo mkdir -p ~username/.ssh
$ touch $HOME/.ssh/authorized_keys
$ sudo sh -c "cat $HOME/.ssh/authorized_keys >> ~username/.ssh/authorized_keys"
$ sudo chown -R username: ~username/.ssh
$ sudo chmod 700 ~username/.ssh
$ sudo sh -c "chmod 600 ~username/.ssh/*"
```
## Install and Setup Git

- Run below command to install 
```shell
$ sudo apt-get install git
```
- Setup git
```shell
$ git config --global user.name "Your Name"
$ git config --global user.email "youremail@domain.com"
```
- Verify configurations
```shell
$ git config --list
```
- Generate SSH key to access your GitHub account from the server 
  - [Click here](https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/)
- Add SSH key to your GitHub account
  - [Click here](https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/)
- Make SSH key accessible to username created as per above
```shell
$ sudo sh -c "cat $HOME/.ssh/id_rsa >> ~username/.ssh/id_rsa"
$ sudo sh -c "cat $HOME/.ssh/id_rsa.pub >> ~username/.ssh/id_rsa.pub”
```
- Test SSH connection with GitHub
  - [Click here](https://help.github.com/articles/testing-your-ssh-connection/)
  
## Setup code

- Prepare directory structure 
```shell
$ sudo mkdir -p /var/www/yourappname
$ sudo chown username: /var/www/yourappname (make it accessible to username created as per above)
```
- Go to directory
```shell
$ cd /var/www/yourappname
```
- Clone code of your rails app. Alternatively you can use my sample app (https://github.com/rutisyrz/passenger_nginx_rails_sample_app)
```shell
$ git clone git://github.com/username/yourappname.git code
```
- **Note:** Run command “*sudo chmod 777 /var/www/yourappname/*” incase you get “*fatal: could not create work tree dir 'code'.: Permission denied*” error while cloning repository.

## Setup environment

- Login as a new user - username
```shell
$ sudo -u username -H bash -l
```
- Set ruby version in RVM 
```shell
$ rvm use ruby  2.1.2
```
- Install MySQL client package
```shell
$ sudo apt-get install mysql-client libmysqlclient-dev
```
- Go to app root directory
```shell
$ cd /var/www/yourappname/code
```
- Install bundle
```shell
$ bundle install --deployment --without development test
```
  - **ERROR:** There was an error while trying to write to `*/var/www/yourappname/code/.bundle/config*`. It is likely that you need to grant write permissions for that path. Run command -
```shell
$ sudo chmod -R 777 /var/www/cloud_monitor_agent/code/.bundle/
```
  - **ERROR:** While executing gem ... (Gem::FilePermissionError)  Run command -
```shell
$ sudo chmod -R 777 /usr/local/rvm/gems/ruby-2.1.2
```
- Assuming you have updated your database.yml with valid config details. If not, please update the same
- Generate and update unique secret key for Staging environment. 
  - Run command
```shell
$ bundle exec rake secret
```
  - Update *config/secrets.yml* file with value generated by above command 
```shell
$ sudo vi config/secrets.yml
```
```ruby
      staging:
        secret_key_base: <%=ENV["SECRET_KEY_BASE"]%>
```        
- Create a log file for Staging environment with “0666” permission
```shell
$ sudo touch log/staging.log
$ sudo chmod 0666 log/staging.log 
```
- Setup database 
```ruby
$ bundle exec rake db:setup RAILS_ENV=staging
$ bundle exec rake db:migrate RAILS_ENV=staging
```
- Compile assets 
```ruby
$ bundle exec rake assets:precompile RAILS_ENV=staging
```
## Configure Nginx and Passenger

- Run command 
  - $ passenger-config about ruby-command
- Copy path after “Command:” in result printed and paste it somewhere in text file. We’ll use it later in this tutorial

- Go back to admin account (ubuntu) user by running a command “exit”

- Create an Nginx configuration file and setup a virtual host entry that points to your app
  -  $ sudo vi /etc/nginx/sites-enabled/yourappname.conf
- Copy + Paste below content (with proper valid formatting)
	```ruby
  server {
    listen 80;
    server_name  <elastic ip / ec2 public dns>;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/yourappname/code/public;

    # Turn on Passenger
    passenger_enabled on;
    rails_env staging;  # Add this line to run app in staging env.
    passenger_ruby /ruby-path; # Replace with path copied from result as mentioned above
  }
  ```
- Save file
- Restart nginx. Run command
```shell
$ sudo service nginx restart
```
## See your app running 

- http://*elastic ip* OR *ec2 public dns*
- Or run command 
```shell
$ curl http://elastic ipORec2 public dns
```
## AWS AMI

- Create Image of EC2 instance to fast-track the server config process next time when you are in need of more similar app servers
- Go to **EC2 dashboard**, select instance
- Click on “*Action*”
- Select option “*Image*”
  - Select option “*Create Image*”

## References

- https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/
- https://help.github.com/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent/
- http://tecadmin.net/install-mongodb-on-ubuntu/
- https://www.digitalocean.com/community/tutorials/how-to-install-mongodb-on-ubuntu-14-04
