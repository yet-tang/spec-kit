#!/usr/bin/env pwsh
# Get feature information for Context Engineering enhanced commands
# PowerShell version of get-feature-info.sh

[CmdletBinding()]
param(
    [switch]$Json,
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$FeatureArgs
)

$ErrorActionPreference = 'Stop'

# Show help if requested
if ($Help) {
    Write-Output "Usage: ./get-feature-info.ps1 [-Json] [feature_args]"
    Write-Output "  -Json     Output results in JSON format (required for Context Engineering)"
    Write-Output "  -Help     Show this help message"
    exit 0
}

# Load common functions
. "$PSScriptRoot/common.ps1"

# Get all paths and variables from common functions
$paths = Get-FeaturePathsEnv

# Function to check if file exists and is readable
function Test-FileReadable {
    param([string]$FilePath)
    return (Test-Path $FilePath -PathType Leaf)
}

# Function to get available documentation files
function Get-AvailableDocs {
    param([string]$FeatureDir)
    
    $docs = @()
    
    # Check for standard documentation files
    $standardDocs = @('spec.md', 'plan.md', 'data-model.md', 'research.md', 'quickstart.md', 'tasks.md')
    
    foreach ($doc in $standardDocs) {
        $filePath = Join-Path $FeatureDir $doc
        if (Test-Path $filePath) {
            $docs += $doc
        }
    }
    
    # Check for contracts directory
    $contractsDir = Join-Path $FeatureDir 'contracts'
    if (Test-Path $contractsDir -PathType Container) {
        $docs += 'contracts/'
    }
    
    # Check for Context Engineering specific files
    $contextDocs = @('context-analysis.md', 'validation-plan.md', 'complexity-assessment.md')
    
    foreach ($doc in $contextDocs) {
        $filePath = Join-Path $FeatureDir $doc
        if (Test-Path $filePath) {
            $docs += $doc
        }
    }
    
    return $docs
}

# Function to get feature complexity level
function Get-ComplexityLevel {
    param([string]$SpecFile)
    
    if (Test-Path $SpecFile) {
        try {
            $content = Get-Content $SpecFile -Raw
            
            # Try to extract complexity level from spec file
            if ($content -match '上下文工程级别|context.*level|complexity.*level[：:]\s*([^\s\r\n]+)') {
                $complexity = $matches[1].ToLower()
                
                switch -Regex ($complexity) {
                    '轻量级|lightweight|light' { return 'lightweight' }
                    '标准|standard|normal' { return 'standard' }
                    '深度|deep|advanced' { return 'deep' }
                    'ultra|critical' { return 'ultrathink' }
                    default { return 'standard' }
                }
            }
        } catch {
            # If file reading fails, return default
        }
    }
    
    return 'standard'
}

# Function to get project type
function Get-ProjectType {
    param([string]$RepoRoot)
    
    # Check for common project indicators
    if (Test-Path (Join-Path $RepoRoot 'package.json')) {
        return 'web'
    } elseif (Test-Path (Join-Path $RepoRoot 'Cargo.toml')) {
        return 'rust'
    } elseif (Test-Path (Join-Path $RepoRoot 'go.mod')) {
        return 'go'
    } elseif ((Test-Path (Join-Path $RepoRoot 'requirements.txt')) -or (Test-Path (Join-Path $RepoRoot 'pyproject.toml'))) {
        return 'python'
    } elseif ((Test-Path (Join-Path $RepoRoot 'pom.xml')) -or (Test-Path (Join-Path $RepoRoot 'build.gradle'))) {
        return 'java'
    } elseif (Test-Path (Join-Path $RepoRoot 'Package.swift')) {
        return 'swift'
    } else {
        return 'unknown'
    }
}

# Main execution
function Main {
    # Ensure we have a valid feature directory
    if (-not (Test-Path $paths.FEATURE_DIR -PathType Container)) {
        if ($Json) {
            $errorObj = @{
                error = 'Feature directory not found'
                feature_dir = $paths.FEATURE_DIR
            }
            Write-Output ($errorObj | ConvertTo-Json -Compress)
        } else {
            Write-Error "Feature directory not found: $($paths.FEATURE_DIR)"
        }
        exit 1
    }
    
    # Get available documentation
    $availableDocs = Get-AvailableDocs $paths.FEATURE_DIR
    
    # Get complexity level
    $complexity = Get-ComplexityLevel $paths.FEATURE_SPEC
    
    # Get project type
    $projectType = Get-ProjectType $paths.REPO_ROOT
    
    # Check if key files exist
    $specExists = Test-FileReadable $paths.FEATURE_SPEC
    $planExists = Test-FileReadable $paths.IMPL_PLAN
    
    if ($Json) {
        # Output comprehensive JSON for Context Engineering
        $result = [PSCustomObject]@{
            REPO_ROOT = $paths.REPO_ROOT
            FEATURE_DIR = $paths.FEATURE_DIR
            FEATURE_SPEC = $paths.FEATURE_SPEC
            IMPLEMENTATION_PLAN = $paths.IMPL_PLAN
            BRANCH_NAME = $paths.CURRENT_BRANCH
            AVAILABLE_DOCS = $availableDocs
            SPEC_EXISTS = $specExists
            PLAN_EXISTS = $planExists
            COMPLEXITY_LEVEL = $complexity
            PROJECT_TYPE = $projectType
            HAS_GIT = $paths.HAS_GIT
            CONTEXT_ENGINEERING = [PSCustomObject]@{
                enabled = $true
                version = '1.0'
                features = @('deep_analysis', 'smart_validation', 'dependency_optimization')
            }
        }
        
        Write-Output ($result | ConvertTo-Json -Depth 10)
    } else {
        # Output human-readable format
        Write-Output "Feature Information:"
        Write-Output "  Repository Root: $($paths.REPO_ROOT)"
        Write-Output "  Feature Directory: $($paths.FEATURE_DIR)"
        Write-Output "  Feature Spec: $($paths.FEATURE_SPEC) (exists: $specExists)"
        Write-Output "  Implementation Plan: $($paths.IMPL_PLAN) (exists: $planExists)"
        Write-Output "  Branch Name: $($paths.CURRENT_BRANCH)"
        Write-Output "  Complexity Level: $complexity"
        Write-Output "  Project Type: $projectType"
        Write-Output "  Available Documents:"
        foreach ($doc in $availableDocs) {
            Write-Output "    - $doc"
        }
    }
}

# Run main function
Main