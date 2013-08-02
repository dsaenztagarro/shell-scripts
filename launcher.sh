#!/bin/bash

help() {
  echo "launcher [-p project-name]"
  exit 2
}

throw_error() {
  case $1 in
    1) show_available_projects; echo 'error(1): Unknown project folder' ;;
    2) echo 'error(2): Mandatory option [-p project-name]' ;;
    3) echo 'error(3): Unknown project' ;;
    \?) echo 'error(1000): Unknown error' ;;
  esac
  exit -1
}

go_to_dir() {
  if [ -d "/Users/dst/dev/projects/$1" ]; then
    cd ~/dev/projects/$1
  else
    throw_error 1
  fi
}

show_available_projects() {
  echo 'Available projects:'
  for entry in `ls ~/dev/projects`; do
      echo "- $entry"
  done
}

# The 1 denotes standard output (stdout). The 2 denotes standard error (stderr).
# So 2>&1 says to send standard error to where ever standard output is being 
# redirected as well. Which since it's being sent to /dev/null is akin to 
# ignoring any output at all.
get_or_up_dbserver() {
  if [ $1 = 'mysql' ]; then
    ping -c1 -w1 192.168.100.100 > /dev/null 2>&1
    if [ "$?" -eq "0" ]; then
      cd ~/dev/vms
      vagrant up mysql
    else
      echo 'INFO: MySQL server already running'
    fi
  fi
}

launch_tmux_django() {
  tmux new-session -d -s $project
  tmux rename-window 'vim'
  tmux new-window -t $project:1 -n 'devserver'
  tmux new-window -t $project:2 -n 'bash'
  tmux new-window -t $project:3 -n 'shell'
  tmux new-window -t $project:4 -n 'mysql'
  tmux new-window -t $project:5 -n 'apache'
  
  tmux send-keys -t $project:0 "vim" Enter
  tmux send-keys -t $project:1 "source /usr/local/pythonenv/$project/bin/activate" Enter
  tmux send-keys -t $project:1 'python manage.py runserver' Enter
  tmux send-keys -t $project:3 "source /usr/local/pythonenv/$project/bin/activate" Enter
  tmux send-keys -t $project:3 'python manage.py shell' Enter  
}

launch_tmux_django_celery() {
  launch_tmux_django
  # custom tmux windows 
  tmux new-window -t $project:6 -n 'celery'
  tmux new-window -t $project:7 -n 'redis'
  tmux new-window -t $project:8 -n 'nodejs'

  tmux send-keys -t $project:4 'mysql --database=django_celery_dev' Enter
  # init focus 
  tmux select-window -t $project:0
}

launch_tmux_django_cirujanos() {
  launch_tmux_django

  tmux send-keys -t $project:4 'mysql --database=django_cirujia_dev' Enter
  # init focus
  tmux select-window -t $project:0
}

projectFlag=false

while getopts ":p:d:" option; do
  case $option in
    p) projectFlag=true; project=$OPTARG ;;
    d) database=$OPTARG ;;
    \?) help ;;
  esac
done

if ! $projectFlag; then
  throw_error 2
fi

go_to_dir $project

if [ $project = 'django-celery' ]; then
  get_or_up_dbserver 'mysql'
  launch_tmux_django_celery
elif [ $project = 'django-cirujanos' ]; then
  get_or_up_dbserver 'mysql'
  launch_tmux_django_cirujanos
else
  throw_error 3
fi

tmux attach -t $project
