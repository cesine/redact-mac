#!/bin/bash

# Remove as many refs as possible
git remote -v
git remote rm origin
git branch -a

# Example Clean binary/log files
echo -e "Cleaning files (for example binary or temp files which shouldnt be in the repo)"
git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch *.obo' \
--prune-empty --tag-name-filter cat -- --all

git filter-branch --force --index-filter \
'git rm --cached --ignore-unmatch *.png' \
--prune-empty --tag-name-filter cat -- --all


# Example Clean author emails
echo -e "\nCleaning authors (for example unifying email addresses etc)"
git filter-branch -f --env-filter 'if [ "$GIT_AUTHOR_EMAIL" = "lynn.schriml@gmail.com" ]; then
     GIT_AUTHOR_EMAIL=ls@host;
     GIT_AUTHOR_NAME="LS";
     GIT_COMMITTER_EMAIL=$GIT_AUTHOR_EMAIL;
     GIT_COMMITTER_NAME="$GIT_AUTHOR_NAME"; fi' -- --all

# Example clean text in files or filenames
# Using perl instead of sed  (sed on BSD/mac doesnt support those options)
# Based on https://devsector.wordpress.com/2014/10/05/advanced-git-branch-filtering/#tree-filter
echo -e "\nCleaning text from commits and filenames (for example removing internal info)"
git filter-branch -f --tree-filter '

    find . | while read file
    do

        # Replacing text in files using any regex in perl
        if [ -f "$file" ]
        then
            echo "\n  Replacing regex in $file";
            perl -pi -e "
            s/(bleeding|blood)/BLOOD/gi
            " "$file"

            perl -pi -e "
            s/malaise/TIRED/gi
            " "$file"
        fi

        # Renaming files/directories
        if [[ $file =~ ^.*symp.*$ ]]
        then
            echo
            redacted=`echo $file | perl -lne "s/symp/symptom/g; print;"`;
            redactedPath=`echo $redacted | perl -lne "s/\/[^\/]*$//; print;"`;

            if [ -d "$file" ]
            then
                echo "$file is a directory"
            else
                # tree
                echo "\n $file is a file"
                echo "  for $file making directories $redactedPath"
                mkdir -p $redactedPath
                echo "  Renaming $file to $redacted";
                git mv "$file" "$redacted"
                # tree
            fi

        fi

    done

' --tag-name-filter cat -- --all
