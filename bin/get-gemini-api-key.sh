#! bin/bash

# This script retrieves the Gemini API key for the personal blog from 1Password.

API_KEY=$(op item get "Personal Blog Gemini API Key" --format json --fields notesPlain | jq -r .value)
export GEMINI_API_KEY="$API_KEY"
echo "Gemini API key retrieved and set as environment variable."