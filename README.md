Shell scripts
=============

**launcher.sh (bash)**

This script allows me to launch my custom development environment for each project.
For every project a customized "combo" of TMUX and Vim is launched.
This script verifies that the projects really exits. 
If the project is not found the list of current projects will be shown.
For the launched project the development server and database will be started. 
The process includes "ping" to the development database machine for verification. 


**deployer.py**

This script allows me to deploy locally every Django project in an Apache Server
