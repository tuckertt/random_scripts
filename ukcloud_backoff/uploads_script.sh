#!/bin/bash

#import private data from text file
source $PWD/secured_items.txt

# setup variables
privacy="true"
commit_message="initial_commit from UKCloud bitbucket"


cd to_be_processed
origin_folder=$PWD

for file in *.zip; do 
  directory_name=$(echo $file | sed 's/-master.*//')
  echo "--------------------------------------------------------"
  echo "processing for repo $directory_name" 
  unzip -q "${file}"  -d $directory_name && rm "${file}"
  
#Create post data so to not have an error around "private"
  post_data="{\"name\":\"$directory_name\", \"private\":\"$privacy\"}"

#create repo in git
  curl -s -H "Authorization: token $git_auth_token"  --data "$post_data" https://api.github.com/user/repos

  cd $directory_name

  git init
  git add *
  git commit -m "$commit_message"
  git branch -M master
  git remote add origin git@github.com:$username/$directory_name.git
  git push -u origin master
  
  cd $origin_folder
  rm -rf $directory_name

done
