#!/bin/bash

#import private data from text file
source $PWD/secured_items.txt

# setup variables
privacy="true"
commit_message="initial_commit from UKCloud bitbucket"
repo_preface="Internal_export-ANSIBLE_COLLECTIONS"

cd to_be_processed
origin_folder=$PWD

for file in *.zip; do 
  echo "$file" 
  if [ -z "$file" ]; then
    echo "no zips found apparently, quitting"
    exit 1
  fi

  directory_name=$(echo $file | sed 's/-master.*//')

  echo "--------------------------------------------------------" >> log.txt
  echo "processing for repo $directory_name" >> log.txt

  unzip -q "${file}"  -d $directory_name && rm "${file}"
  
# Create post data so to not have an error around "private"
  post_data="{\"name\":\"$repo_preface-$directory_name\", \"private\":\"$privacy\"}"

# Create repo in git based on if the area is organizational or personal and sets the endpoint variable. Quits if neither
  if [ -n "$organization_account_name" ]; then

    curl -s -H "Authorization: token $git_auth_token"  --data "$post_data" https://api.github.com/orgs/UKCloud/repos
    git_endpoint=$organization_account_name/$repo_preface-$directory_name.git

  elif [ -n "$personal_account_name" ]; then

    curl -s -H "Authorization: token $git_auth_token"  --data "$post_data" https://api.github.com/user/repos
    git_endpoint=$personal_account_name/$repo_preface-$directory_name.git

  else

    echo "neither Organization nor Personal account name found. Unable to upload to an unknown area, exiting"
    exit 2

  fi

# Moves into the un-zipped area and configures git, pointing it to the git endpoint and pushes up to the remote
  cd $directory_name

  git init
  git add *
  git commit -m "$commit_message"
  git branch -M master
  git remote add origin git@github.com:$git_endpoint
  git push -u origin master
  
# Returns to the origin directory and cleans up the folder
  cd $origin_folder
  rm -rf $directory_name
  echo "completed upload of $directory_name to $username git area" >> log.txt
done
