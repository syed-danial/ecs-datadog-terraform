#!/bin/bash

# Check if the correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 [semantic_version] [branch_name]"
    exit 1
fi

# Arguments
semantic_version=$1
branch_name=$2

# Function to update .tfvars file
update_tfvars() {
    local version=$1
    local file_path=$2
    # Use sed to replace the semantic_version attribute
    sed -i "s/semantic_version *= *\".*\"/semantic_version = \"$version\"/g" "$file_path"
}

# Conditional logic based on the branch name
case $branch_name in
    dev)
        update_tfvars $semantic_version "tfvars/dev/dev.tfvars"
        ;;
    stage)
        update_tfvars $semantic_version "tfvars/stage/stage.tfvars"
        ;;
    prod)
        update_tfvars $semantic_version "tfvars/dev/dev.tfvars"
        update_tfvars $semantic_version "tfvars/stage/stage.tfvars"
        update_tfvars $semantic_version "tfvars/prod/prod.tfvars"
        ;;
    *)
        echo "Invalid branch name. Valid options are dev, stage, or prod."
        exit 1
        ;;
esac

echo "Updated $branch_name tfvars with semantic version $semantic_version"

echo "$semantic_version" > next_version.txt
