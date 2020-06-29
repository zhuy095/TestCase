#!/bin/bash
# See the link to view principle.
# http://blog.csdn.net/lwfcgz/article/details/49453375
if [ $# != 2 ]
then
	echo "Usage $0 year month"
	echo "to delete repo before year:month."
	exit 1
fi


if [[ $2 -ge 9 ]]
then
	delete_file="testlink_back_${1}[1-${2}]*tar.gz"
else
	delete_file="testlink_back_${1}0[1-${2}]*tar.gz"
fi

echo "clear object file : $delete_file"

git filter-branch --force --index-filter "git rm --cached --ignore-unmatch $delete_file" --prune-empty --tag-name-filter cat -- --all
#git filter-branch --index-filter "git rm --cached --ignore-unmatch $delete_file" HEAD
#git for-each-ref --format="%(refname)" refs/original/ | xargs -n 1 git update-ref -d


# force push 
echo "force push"
#git reflog expire --expire=now --all
#git gc --prune=now
git push --all --force
