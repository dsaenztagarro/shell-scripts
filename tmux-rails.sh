#/bin/sh
SESSION='rails-dashboard'

cd ~/dev/projects/rails-dashboard 

tmux new-session -d -s $SESSION

tmux rename-window 'ide'
tmux new-window -t $SESSION:1 -n 'rspec'
tmux new-window -t $SESSION:2 -n 'cucumber'
tmux new-window -t $SESSION:3 -n 'guard'
tmux new-window -t $SESSION:4 -n 'spork'
tmux new-window -t $SESSION:5 -n 'server'
tmux new-window -t $SESSION:6 -n 'db'
tmux new-window -t $SESSION:7 -n 'shell'
tmux new-window -t $SESSION:8 -n 'irb'
tmux new-window -t $SESSION:9 -n 'scripts'
