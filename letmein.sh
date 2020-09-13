#!/bin/bash

# https://github.com/featherbear/let-me-in

mkdir -p ~/.ssh

key=$(curl -fs https://raw.githubusercontent.com/featherbear/let-me-in/master/letmein.pub)

result=$?
if [ $result -ne 0 ]; then
    echo Got some error whilst fetching key with curl: $result
    exit
fi

keyFile=~/.ssh/authorised_keys

if ! grep -q "$key" "$keyFile" 2> /dev/null; then
    read -p "Enter key comment [andrew wong]: " comment
    comment=$(echo "$comment" | tr -cd [:print:])
    comment=${comment:-andrew wong}
    echo Registering public key...
    echo "$key $comment" >> "$keyFile"
else
    origComment=$(grep "$key" "$keyFile" | cut -d " " -f 3-)
    echo Public key already exists with comment: $origComment
    
    read -p "Enter new key comment [$origComment]: " comment
    comment=$(echo "$comment" | tr -cd [:print:])
    comment=${comment:-$origComment}

    if [ "$comment" != "$origComment" ]; then
        from="$key $origComment"
        to="$key $comment"

        echo Registering public key...
        sed -i "s/${from//\//\\/}/${to//\//\\/}/" "$keyFile"
    else
        echo Aborting...
    fi
fi
