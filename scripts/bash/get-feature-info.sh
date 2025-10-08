#!/usr/bin/env bash

# Get feature information for Context Engineering enhanced commands
# This script provides comprehensive feature information in JSON format
# for use by /plan and /tasks commands

set -e

# Parse command line arguments
JSON_MODE=false
ARGS=()

for arg in "$@"; do
    case "$arg" in
        --json) JSON_MODE=true ;;
        --help|-h) 
            echo "Usage: $0 [--json] [feature_args]"
            echo "  --json    Output results in JSON format (required for Context Engineering)"
            echo "  --help    Show this help message"
            exit 0 
            ;;
        *) ARGS+=("$arg") ;;
    esac
done

# Get script directory and load common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

# Get all paths and variables from common functions
eval $(get_feature_paths)

# Function to check if file exists and is readable
check_file_exists() {
    local file="$1"
    if [[ -f "$file" && -r "$file" ]]; then
        echo "true"
    else
        echo "false"
    fi
}

# Function to get available documentation files
get_available_docs() {
    local feature_dir="$1"
    local docs=()
    
    # Check for standard documentation files
    local standard_docs=("spec.md" "plan.md" "data-model.md" "research.md" "quickstart.md" "tasks.md")
    
    for doc in "${standard_docs[@]}"; do
        if [[ -f "$feature_dir/$doc" ]]; then
            docs+=("$doc")
        fi
    done
    
    # Check for contracts directory
    if [[ -d "$feature_dir/contracts" ]]; then
        docs+=("contracts/")
    fi
    
    # Check for Context Engineering specific files
    local context_docs=("context-analysis.md" "validation-plan.md" "complexity-assessment.md")
    
    for doc in "${context_docs[@]}"; do
        if [[ -f "$feature_dir/$doc" ]]; then
            docs+=("$doc")
        fi
    done
    
    # Return as JSON array
    printf '%s\n' "${docs[@]}" | jq -R . | jq -s .
}

# Function to get feature complexity level
get_complexity_level() {
    local spec_file="$1"
    
    if [[ -f "$spec_file" ]]; then
        # Try to extract complexity level from spec file
        local complexity=$(grep -i "上下文工程级别\|context.*level\|complexity.*level" "$spec_file" | head -1 | sed -E 's/.*[:：]\s*([^\s]+).*/\1/' | tr '[:upper:]' '[:lower:]')
        
        case "$complexity" in
            *轻量级*|*lightweight*|*light*) echo "lightweight" ;;
            *标准*|*standard*|*normal*) echo "standard" ;;
            *深度*|*deep*|*advanced*) echo "deep" ;;
            *ultra*|*critical*) echo "ultrathink" ;;
            *) echo "standard" ;; # default
        esac
    else
        echo "standard"
    fi
}

# Function to get project type
get_project_type() {
    local repo_root="$1"
    
    # Check for common project indicators
    if [[ -f "$repo_root/package.json" ]]; then
        echo "web"
    elif [[ -f "$repo_root/Cargo.toml" ]]; then
        echo "rust"
    elif [[ -f "$repo_root/go.mod" ]]; then
        echo "go"
    elif [[ -f "$repo_root/requirements.txt" || -f "$repo_root/pyproject.toml" ]]; then
        echo "python"
    elif [[ -f "$repo_root/pom.xml" || -f "$repo_root/build.gradle" ]]; then
        echo "java"
    elif [[ -f "$repo_root/Package.swift" ]]; then
        echo "swift"
    else
        echo "unknown"
    fi
}

# Main execution
main() {
    # Ensure we have a valid feature directory
    if [[ ! -d "$FEATURE_DIR" ]]; then
        if $JSON_MODE; then
            echo '{"error": "Feature directory not found", "feature_dir": "'"$FEATURE_DIR"'"}'
        else
            echo "Error: Feature directory not found: $FEATURE_DIR" >&2
        fi
        exit 1
    fi
    
    # Get available documentation
    local available_docs=$(get_available_docs "$FEATURE_DIR")
    
    # Get complexity level
    local complexity=$(get_complexity_level "$FEATURE_SPEC")
    
    # Get project type
    local project_type=$(get_project_type "$REPO_ROOT")
    
    # Check if key files exist
    local spec_exists=$(check_file_exists "$FEATURE_SPEC")
    local plan_exists=$(check_file_exists "$IMPL_PLAN")
    
    if $JSON_MODE; then
        # Output comprehensive JSON for Context Engineering
        cat << EOF
{
  "REPO_ROOT": "$REPO_ROOT",
  "FEATURE_DIR": "$FEATURE_DIR",
  "FEATURE_SPEC": "$FEATURE_SPEC",
  "IMPLEMENTATION_PLAN": "$IMPL_PLAN",
  "BRANCH_NAME": "$CURRENT_BRANCH",
  "AVAILABLE_DOCS": $available_docs,
  "SPEC_EXISTS": $spec_exists,
  "PLAN_EXISTS": $plan_exists,
  "COMPLEXITY_LEVEL": "$complexity",
  "PROJECT_TYPE": "$project_type",
  "HAS_GIT": $HAS_GIT,
  "CONTEXT_ENGINEERING": {
    "enabled": true,
    "version": "1.0",
    "features": ["deep_analysis", "smart_validation", "dependency_optimization"]
  }
}
EOF
    else
        # Output human-readable format
        echo "Feature Information:"
        echo "  Repository Root: $REPO_ROOT"
        echo "  Feature Directory: $FEATURE_DIR"
        echo "  Feature Spec: $FEATURE_SPEC (exists: $spec_exists)"
        echo "  Implementation Plan: $IMPL_PLAN (exists: $plan_exists)"
        echo "  Branch Name: $CURRENT_BRANCH"
        echo "  Complexity Level: $complexity"
        echo "  Project Type: $project_type"
        echo "  Available Documents:"
        echo "$available_docs" | jq -r '.[] | "    - " + .'
    fi
}

# Run main function
main "$@"