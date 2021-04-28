# Certified
Hyperledger Fabric based Certificate Verification System


# Prerequisition:
Make sure you have hyperledger fabric binaries, GoLang, Docker, Docker Container, node installed in your system. And all the path added correctly to system.
also install nodemon package 
command : npm install -g nodemon
For details visit https://hyperledger-fabric.readthedocs.io/en/release-2.2/prereqs.html

# How to Run this project:

Clone this repo to your local machine. Make sure you are using ubuntu / any other linux distros. 

1.Open a terminal and run down.sh file
command : ./down.sh
This will take down all the dokcer container running previously on your system

2. Now run up.sh
command : ./up.sh
This will bring up the network 

3. Chage the directory to api-2.0
command : cd api-2.0

4. Run the following command : npm install
This will install all the dependency required for this project.
now run : nodemon app.js

5.If you get the error : "Internal watch failed: ENOSPC: System limit for number of file watchers reached"
run : echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

6. If everything is done correctly, server will be up and runnig on port 4000
go to the browser and type localhost:4000/register to register a new id
you must provide the Organization either 'sust' or 'startech' (case sensitive).

7.Now log in using the credentials.

8. If you registered as 'sust' you'll be able to upload student data. Fill up every field and upload.

9. Now GO tho the "Query Certificate" option and fill up the fields.

10. Click Submit and you'll be able to see the certificate.

11. If you log in as 'startech' you'll be able to query data only. 


