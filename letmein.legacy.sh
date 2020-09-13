#!/bin/bash

# https://github.com/featherbear/let-me-in

mkdir -p ~/.ssh

key="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDIRUGwKjHtkjwuoRaaWz7O8bmADq/iIr6Jr41ld7DRJ1zXiMMzl3/cCFPC0XAWtXoWaua9gf2UEjLHT81o04Z2e1Xkas6Z6hszU902dXfCAE3Z/WZKDl9gQ7CtMthl99KwXcyACv4KPQVmf52f9OhSoKUGBiR9/IHuFw6YcHbJYpvvKIDr0ACS8lmE3k6ta0l99crIFoWIxbq/PsTHvQ1UkEHXVOvVMP5kAUAptz7jvd+BIUpeQ1nHnFI/zmNSrGlR5L+mgYyjrJeddcRLtvabMkfS6m5KN8ikE54uyyrKzgBSR9zoBomUCc/Cwqh4qD41iLnUPc8jfzJoNdj04y6OQoqdo2ZZsjsrah1PKfo1fjlZzwjKPloY9wsZ2gH8ROrhYXL81NuxcxnvchtDdA3q4e9opkABByZy+qnkyFUCIcgiJOmwJXGhxApohqiUbtOjegGTj85QAVqMjwRY7GvjbCCXFOwxFvabMWXUsnlEbey5FJPGLC95RAo9ySoWNc0="

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
