#!/usr/bin/env bash

set -e
set -o pipefail

# Script for Git repos housing mibank services. These repos are mounted as
# data volumes into their corresponding Docker containers to facilitate development.
# Repos are cloned to/removed from the directory above the one housing this file.

if [ -z "$DEVSTACK_WORKSPACE" ]; then
    echo "need to set workspace dir"
    exit 1
elif [ -d "$DEVSTACK_WORKSPACE" ]; then
    cd $DEVSTACK_WORKSPACE
else
    echo "Workspace directory $DEVSTACK_WORKSPACE doesn't exist"
    exit 1
fi

# repos as string in the form "<repo url>;<repo destination folder>"
repos=(
    "git@bitbucket.org:pappcorn/mibank-web-service.git;mibank_django_project"
    "git@bitbucket.org:pappcorn/mibank-mobile-app.git;mibank_mobileapp"
)

name_pattern=".*mibank(.*).git"

_clone ()
{
    # for repo in ${repos[*]}
    repos_to_clone=("$@")

    for repo in "${repos_to_clone[@]}"
    do
        # Getting repo and destination first
        temp_arr=(${repo//;/ })
        repo="${temp_arr[0]}"
        dest_repo="${temp_arr[1]}"

        # Use Bash's regex match operator to capture the name of the repo.
        # Results of the match are saved to an array called $BASH_REMATCH.
        [[ $repo =~ $name_pattern ]]
        name="${BASH_REMATCH[1]}"

        if [ -d "$dest_repo" ]; then
            printf "The [%s] repo is already checked out. Continuing.\n" $name
        else
            if [ "${SHALLOW_CLONE}" == "1" ]; then
                git clone --depth=1 $repo $dest_repo
            else
                git clone $repo $dest_repo
            fi
        fi
    done
    cd - &> /dev/null
}

clone ()
{
    _clone "${repos[@]}"
}

reset ()
{
    currDir=$(pwd)
    for repo in ${repos[*]}
    do
        [[ $repo =~ $name_pattern ]]
        name="${BASH_REMATCH[1]}"

        if [ -d "$name" ]; then
            cd $name;git reset --hard HEAD;git checkout master;git reset --hard origin/master;git pull;cd "$currDir"
        else
            printf "The [%s] repo is not cloned. Continuing.\n" $name
        fi
    done
    cd - &> /dev/null
}

status ()
{
    currDir=$(pwd)
    for repo in ${repos[*]}
    do
        [[ $repo =~ $name_pattern ]]
        name="${BASH_REMATCH[1]}"

        if [ -d "$name" ]; then
            printf "\nGit status for [%s]:\n" $name
            cd $name;git status;cd "$currDir"
        else
            printf "The [%s] repo is not cloned. Continuing.\n" $name
        fi
    done
    cd - &> /dev/null
}

if [ "$1" == "clone" ]; then
    clone
elif [ "$1" == "whitelabel" ]; then
    clone_private
elif [ "$1" == "reset" ]; then
    read -p "This will override any uncommited changes in your local git checkouts. Would you like to proceed? [y/n] " -r
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        reset
    fi
elif [ "$1" == "status" ]; then
    status
fi
