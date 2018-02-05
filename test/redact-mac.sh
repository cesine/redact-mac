#!/bin/bash

# clean up from any previous runs
ls SymptomOntology && rm -rf SymptomOntology

# fetch a sample repo with a bit of history
git clone https://github.com/cesine/SymptomOntology.git
cd SymptomOntology

# View the history before
git log

# run redact examples
cd ../SymptomOntology
bash ../redact-mac.sh

echo ""
echo "-----------------------------========================================-----------------------------"
echo "-----------------------------                 RESULT                 -----------------------------"
echo "-----------------------------========================================-----------------------------"

# View the history after
git log

TESTFAILED=0;
TESTSFAILEDSTRING="";

# Test file removal from history
tree | grep *.obo -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ File removal: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ File removal: success"

# Test author changing
git log | grep "gmail.com" -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ Change Author: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ Change Author: success"

# Test filename replacement
tree | grep symp.owl -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ File rename: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ File rename: success"

# Test commit messages
git log --all --grep="symptoms" | grep "symptoms" -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ Commit text replacement: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ Commit text replacement: success"

# Test text replacement
grep "bleeding" *.owl -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ Grouped text replacement: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ Grouped text replacement: success"

# Test text replacement
grep "Malaise" *.owl -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ Case insensitive text replacement: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ Case insensitive text replacement: success"

echo -e "\n$TESTFAILED failed";
echo -e "$TESTSFAILEDSTRING";

if [ $TESTFAILED = 0 ]; then
  exit 0;
else
  exit 1;
fi
