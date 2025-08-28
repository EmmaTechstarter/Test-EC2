#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   HOSTS="1.2.3.4,5.6.7.8" USER=ubuntu KEY_PATH=/tmp/key index_path=index.html ./scripts/push_index.sh

IFS=',' read -ra HLIST <<< "${HOSTS}"
for H in "${HLIST[@]}"; do
  echo ">>> Deploy to $H"
  # kopiere index.html
  scp -o StrictHostKeyChecking=no -i "$KEY_PATH" "$index_path" "${USER}@${H}:/tmp/index.html"
  # verschiebe an den Nginx-Pfad & nginx reload
  ssh -o StrictHostKeyChecking=no -i "$KEY_PATH" "${USER}@${H}" 'sudo mv /tmp/index.html /var/www/html/index.html && sudo systemctl reload nginx || sudo systemctl restart nginx'
done

echo "All done."
