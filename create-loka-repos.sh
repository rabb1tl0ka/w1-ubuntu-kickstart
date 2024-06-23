# Create ~/loka if it doesn't exist
loka_directory="$HOME/loka"
if [ ! -d "$loka_directory" ]; then
    mkdir -p "$loka_directory"
fi

loka_code_directory="$HOME/loka/code"
if [ ! -d "$loka_code_directory" ]; then
    mkdir -p "$loka_code_directory"
fi

cd "$loka_code_directory" || exit
git clone https://github.com/rabb1tl0ka/cs-db.git
git clone https://github.com/rabb1tl0ka/cs-tools-code.git
git clone https://github.com/rabb1tl0ka/cs-test-data.git
git clone https://github.com/cloudsort/backend-jailbreak.git
git clone https://github.com/cloudsort/backend.git
