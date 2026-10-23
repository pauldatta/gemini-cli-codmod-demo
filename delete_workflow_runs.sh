#!/bin/bash

# This script deletes all workflow runs for a given repository.

REPO="pauldatta/gemini-cli"

echo "Fetching workflow run IDs for $REPO..."
gh run list -R $REPO --json databaseId -q '.[] | .databaseId' > all_run_ids.txt

if [ ! -s all_run_ids.txt ]; then
  echo "No workflow runs found."
  rm all_run_ids.txt
  exit 0
fi

echo "Deleting workflow runs..."
cat all_run_ids.txt | xargs -n1 -P4 gh run delete

echo "All workflow runs deleted."
rm all_run_ids.txt
