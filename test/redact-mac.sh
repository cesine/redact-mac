#!/bin/bash

# clean up
ls SymptomOntology && rm -rf SymptomOntology

# fetch
git clone https://github.com/DiseaseOntology/SymptomOntology.git
cd SymptomOntology
git remote rm origin
git log -1

# run
cd ../SymptomOntology
bash ../redact-mac.sh

echo "-----------------------------========================================-----------------------------"
echo "-----------------------------                 RESULT                 -----------------------------"
echo "-----------------------------========================================-----------------------------"

TESTFAILED=0;
TESTSFAILEDSTRING="";

# Test file removal from history
tree | grep *.obo -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ File removal: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ File removal: success"

# Test author changing
git log | grep "gmail.com" -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ Change Author: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ Change Author: success"

# Test filename replacement
tree | grep symp.owl -c && { TESTSFAILEDSTRING="$TESTSFAILEDSTRING \n  ❌ File rename: failed"; TESTFAILED=$[TESTFAILED + 1]; } || echo "  ✓ File rename: success"

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
