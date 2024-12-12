alias editbashaliases='code ~/.bash_aliases'
alias mycode='cd ~/code'
alias downloads='cd ~/Downloads'

alias csproddb='gcloud compute ssh --zone "us-central1-c" "production-bastion-host" --project "cloudsort-version1"'
alias csdevdb='gcloud compute ssh --zone "us-central1-c" "development-bastion-host" --project "cloudsort-version1"'
alias cloudsort='cd ~/loka/projects/cloudsort/'
alias cs-code='cd ~/loka/projects/cloudsort/code'
alias cs-db='cd ~/loka/projects/cloudsort/code/cs-db/sql-scripts'
alias cs-tools='cd ~/loka/projects/cloudsort/code/cs-tools-code'
alias jailbreak='cd ~/loka/projects/cloudsort/jailbreak'

alias sirius='cd ~/loka/projects/sirius'
alias siriusproddb='aws ssm start-session --target i-0b52316bd213ad6d3'
alias siriusproddbgo='psql -h sirius-prod.con4gfwbvyio.us-east-1.rds.amazonaws.com -U postgres -d siriustx_db'

alias notifspeaker='cd ~/code/notifspeaker && source env/bin/activate && python3 notifspeaker.py polly'

alias osversion='lsb_release -a'
alias security-encpass='sudo ecryptfs-unwrap-passphrase ~/.ecryptfs/wrapped-passphrase'
alias snaprefresh='snap refresh --list'
alias figma='snap run figma-linux'