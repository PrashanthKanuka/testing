#!/bin/bash

# Replace these variables with your GitHub username and access token
GITHUB_USERNAME="PrashanthKanuka"
GITHUB_TOKEN="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"
#GITHUB_TOKEN=${Github_Repo.PrashanthKanuka}
REPO_NAME="New-updated31"
BRANCH_NAME="feature"
BASE_BRANCH="main"

 

# Check if the repository exists
check_repo_existence() {
    repo_url="https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME"
    response=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "$repo_url")
    if [[ "$response" == *"Not Found"* ]]; then
        return 1  # Repository does not exist
    else
        return 0  # Repository exists
    fi
}

 

# Create the repository
create_github_repository() {
    curl -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "https://api.github.com/user/repos" -d "{\"name\":\"$REPO_NAME\", \"private\": true, \"auto_init\":true}"
}

 
# Check if the response contains any errors
error=$(echo "$response" | jq -r '.message')
if [ "$error" != "null" ]; then
    echo "Error creating the repository: $error"
    exit 1
fi

# Main script
check_repo_existence
if [ $? -eq 1 ]; then
    echo "Repository does not exist. Creating the repository..."
    create_github_repository
    echo "Repository created successfully!"
else
    echo "Repository already exists."
fi



# API endpoint to create a new branch
api_url="https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME/git/refs"

# JSON payload to create the branch
json_data="{\"ref\":\"refs/heads/$BRANCH_NAME\",\"sha\":\"$(curl -s -H \"Authorization: token $GITHUB_TOKEN\" -H \"Accept: application/vnd.github.v3+json\" \"https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME/git/refs/heads/$BASE_BRANCH\" | jq -r '.object.sha')\"}"

# Make the API request to create the branch
response=$(curl -X POST -H "Authorization: token $GITHUB_TOKEN" -H "Accept: application/vnd.github.v3+json" "$api_url" -d "$json_data")

# Check if the response contains any errors
error=$(echo "$response" | jq -r '.message')
if [ "$error" != "null" ]; then
    echo "Error creating the branch: $error"
    exit 1
fi

# Branch created successfully
echo "Branch '$branch_name' created in the repository '$repo_name'."


 

# Create a pull request
curl -X POST -H "Authorization: token $GITHUB_TOKEN" -d '{"title":"Feature Update", "body":"Please review this feature update.", "head":"'$BRANCH_NAME'", "base":"main"}' "https://api.github.com/repos/$GITHUB_USERNAME/$REPO_NAME/pulls"
