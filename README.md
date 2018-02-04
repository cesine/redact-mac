[![Build Status][travis-image]][travis-url]

# redact-mac

When you opensource a project, its also better if you can opensource its development. Opensourcing a project's development can help future contributors understand the decisions that lead to its current state and where it could go in the future.

Often times you might have to remove internal info. This repo has a few different types of exmaples of advanced git `filter-branch` which work on large text files, and also which work on MacOS. The git `filter-branch` examples are based on the `sed` examples https://devsector.wordpress.com/2014/10/05/advanced-git-branch-filtering/#tree-filter ported to `perl`.

We initially used BFG https://help.github.com/articles/removing-sensitive-data-from-a-repository but found that it didn't modify commits to large text files such as `.xml` or `.json` files.


## Usage


Copy paste parts of [redact-mac.sh](redact-mac.sh) to a script (for example `redact-mac.sh`) in the root of your repo, then run the script.

```bash
touch ./redact-mac.sh
chmod +x redact-mac.sh
./redact-mac.sh
```


## Development

If you add an example, add tests. This repo has a test example which clones down a sample repo and runs various `git filter-branch` on it:


```bash
$ ./test/redact-mac.sh  || echo "There were failures..."
License   README.md symptom.owl
Cloning into 'SymptomOntology'...
remote: Counting objects: 18, done.
remote: Compressing objects: 100% (12/12), done.
remote: Total 18 (delta 5), reused 18 (delta 5), pack-reused 0
Unpacking objects: 100% (18/18), done.
commit e5e719b5d1e3412b231821cbdbe7bdcc6e9915f1 (HEAD -> master)
Author: lschriml <lynn.schriml@gmail.com>
Date:   Fri Aug 4 11:44:43 2017 -0400

    Create License
Cleaning files (for example binary or temp files which shouldnt be in the repo)
Rewrite 0fc2763ca1e3e267e72e62b696b6e6b7a4a508f1 (2/6) (1 seconds passed, remaining 2 predicted)    rm 'symp.obo'
Rewrite 4000e9c27e9e98e2411dfc1215c2a3dc4ab2fe71 (2/6) (1 seconds passed, remaining 2 predicted)    rm 'symp.obo'
Rewrite 642a2301f39bbe1c353ad9991089fc3a37318da2 (2/6) (1 seconds passed, remaining 2 predicted)    rm 'symp.obo'
Rewrite 7c4c588887040b49491fa4866d08690392decf1b (5/6) (2 seconds passed, remaining 0 predicted)    rm 'symp.obo'
Rewrite e5e719b5d1e3412b231821cbdbe7bdcc6e9915f1 (5/6) (2 seconds passed, remaining 0 predicted)    rm 'symp.obo'

Ref 'refs/heads/master' was rewritten
Rewrite 35d498e041b1b3e287bed7b9be0619da9d9656f6 (3/6) (1 seconds passed, remaining 1 predicted)
WARNING: Ref 'refs/heads/master' is unchanged

Cleaning authors (for example unifying email addresses etc)
Rewrite 35d498e041b1b3e287bed7b9be0619da9d9656f6 (5/6) (2 seconds passed, remaining 0 predicted)
Ref 'refs/heads/master' was rewritten

Cleaning text from commits and filenames (for example removing internal info)
Rewrite 572d6b89d702a87854a4472afac4517718d9f796 (1/6) (0 seconds passed, remaining 0 predicted)
  Replacing text in ./README.md
Rewrite d43aa19f44014151ec57456ee63c7f5c5e39679e (2/6) (1 seconds passed, remaining 2 predicted)
  Replacing text in ./README.md

  Replacing text in ./symp.owl

  Renaming ./symp.owl to ./symptom.owl
Rewrite 028551d889f7afd539b7e9759bb2e31ba9311d84 (2/6) (1 seconds passed, remaining 2 predicted)
  Replacing text in ./README.md

  Replacing text in ./symp.owl

  Renaming ./symp.owl to ./symptom.owl
Rewrite b6b18391422da35b14566c4a50baacd0f7638d7b (2/6) (1 seconds passed, remaining 2 predicted)
  Replacing text in ./README.md

  Replacing text in ./symp.owl

  Renaming ./symp.owl to ./symptom.owl
Rewrite ce275c1320dd2f9a5e3c974ea3ebb799183a4d91 (5/6) (2 seconds passed, remaining 0 predicted)
  Replacing text in ./README.md

  Replacing text in ./symp.owl

  Renaming ./symp.owl to ./symptom.owl
Rewrite d3a546c6854b53d033aca1aea170fa411aa5769b (5/6) (2 seconds passed, remaining 0 predicted)
  Replacing text in ./License

  Replacing text in ./README.md

  Replacing text in ./symp.owl

  Renaming ./symp.owl to ./symptom.owl

Ref 'refs/heads/master' was rewritten

-----------------------------========================================-----------------------------
-----------------------------                 RESULT                 -----------------------------
-----------------------------========================================-----------------------------

0
  ✓ File removal: success
0
  ✓ Change Author: success
0
  ✓ File rename: success
0
  ✓ Grouped text replacement: success
0
  ✓ Case insensitive text replacement: success

0 failed
```

Make sure the tests you add, can also fail:

```bash
-----------------------------========================================-----------------------------
-----------------------------                 RESULT                 -----------------------------
-----------------------------========================================-----------------------------

0
  ✓ File removal: success
0
  ✓ Change Author: success
0
  ✓ File rename: success
100
4

2 failed

  ❌ Grouped text replacement: failed
  ❌ Case insensitive text replacement: failed

There were failures...
  ```


[travis-url]: https://travis-ci.org/cesine/redact-mac
[travis-image]: https://travis-ci.org/cesine/redact-mac.svg?branch=master
