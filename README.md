# stu-docker-laravel-installer
Quick command-line guided installer for latest Laravel development
environment in docker ecosystem with all required containers and tools.sh

Makes installation of a fresh Laravel a breeze and allows to opt in 
for AUTH functions and VueJS Frontend as needed.

## Usage
- Install Docker and Docker-Compose on Development or Production System
- Make sure to clone repository *'atrukturunion-mmw/stu-docker-proxy'* 
from Github (it is needed for local proxy ans ssh services)
- Run *'laravel_install.sh'* to install Laravel instance
- run *'service_up.sh'*&nbsp; to spin up all needed containers
- Take down with *'service_down.sh'*&nbsp; 
- To clear Laravel instance run *'laravel_remove.sh'*