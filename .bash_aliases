alias csproddb='gcloud compute ssh --zone "us-central1-c" "production-backend-bastion" --project "cloudsort-version1"'
alias csdevdb='gcloud compute ssh --zone "us-central1-c" "development-backend-bastion" --project "cloudsort-version1"'


alias cloudsort='cd ~/loka/projects/cloudsort/'
alias cs-code='cd ~/loka/projects/cloudsort/code'
alias cs-db='cd ~/loka/projects/cloudsort/code/cs-db/sql-scripts'
alias cs-tools='cd ~/loka/projects/cloudsort/code/cs-tools-code'
alias notifspeaker='cd ~/code/notifspeaker && source .venv/bin/activate && python3 notifspeaker.py polly'

alias osversion='lsb_release -a'
alias security-encpass='sudo ecryptfs-unwrap-passphrase ~/.ecryptfs/wrapped-passphrase'
