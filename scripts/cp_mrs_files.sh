#!/bin/bash

# === CONFIGURATION ===
# Path to updated files (local)
FILES_TO_DEPLOY=("../tmux/just_flying/config/custom_config_garmin.yaml" 
                    "../tmux/just_flying/scripts/env_ferox.sh")

# Remote directory where files are deployed
REMOTE_DIR="/singularity_poc2/user_ros_workspace/src/mrs_openswarm_real/tmux/just_flying/"

# === DEPLOY FUNCTION ===
deploy_files() {
    local original_host="$1"
    local host="${original_host}_vpn"

    local prefix="${original_host:0:3}"         # "uav"
    local number="${original_host:3}"           # "X"
    local remote_user="${prefix}_${number}"     # "uav_X"

    echo "Deploying to $host..."
    echo "User: $remote_user..."

    for file in "${FILES_TO_DEPLOY[@]}"; do

        parent_dir=$(dirname "$file")
        folder_name=$(basename "$parent_dir")

        scp "$file" "$remote_user@$host:/home/${remote_user}${REMOTE_DIR}${folder_name}/"
        if [ $? -ne 0 ]; then
            echo "❌ Failed to copy $file to $host"
        else
            echo "✅ $file copied to $host"
        fi
    done
}

# === MAIN LOOP ===
echo "Starting..."
# drone_hosts=("uav6" "uav7" "uav8" "uav9" "uav10" "uav11" "uav12" "uav13" "uav14" "uav15")
drone_hosts=("uav8" "uav9" "uav10" "uav11" "uav12" "uav13" "uav14" "uav15")

for host in "${drone_hosts[@]}"; do
    deploy_files "$host"
done

echo "Process completed."