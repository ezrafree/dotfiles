# secrets

# security add-generic-password -a "$USER" -s npm_token -w 'YOUR_TOKEN_HERE'
export NPM_TOKEN="$(security find-generic-password -a "$USER" -s npm_token -w)"
