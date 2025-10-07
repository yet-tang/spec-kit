#!/usr/bin/env pwsh

# 需求验证脚本 (PowerShell版本)
# 检查规格文件是否包含所有必要信息，识别潜在的需求遗漏

param(
    [string]$Scope = "all",
    [switch]$Verbose = $false,
    [switch]$Help = $false,
    [string]$Arguments = ""
)

# 显示帮助信息
function Show-Help {
    Write-Host @"
需求验证脚本 - 检查规格完整性和识别需求遗漏

用法: ./validate-specification.ps1 [选项] [规格文件路径]
选项:
  -Verbose               显示详细输出
  -Scope SCOPE          验证范围 (business|technical|ux|security|all)
  -Help                 显示此帮助信息
  -Arguments ARGUMENTS  验证参数

示例:
  ./validate-specification.ps1 specs/001-user-authentication/spec.md
  ./validate-specification.ps1 -Scope business specs/001-user-authentication/spec.md
  ./validate-specification.ps1 -Verbose -Scope technical specs/001-user-authentication/spec.md
"@
}

# 解析参数
if ($Help) {
    Show-Help
    exit 0
}

# 从Arguments参数中解析规格文件路径
$SpecFile = ""
if ($Arguments) {
    $SpecFile = $Arguments
}

# 如果没有指定规格文件，尝试自动发现
if (-not $SpecFile) {
    # 获取当前分支
    try {
        $CurrentBranch = git rev-parse --abbrev-ref HEAD 2>$null
        if ($LASTEXITCODE -ne 0) {
            $CurrentBranch = "unknown"
        }
    } catch {
        $CurrentBranch = "unknown"
    }

    # 尝试找到规格文件
    $PossibleFiles = @(
        "specs/$CurrentBranch/spec.md",
        "specs/spec.md",
        "spec.md"
    )

    foreach ($file in $PossibleFiles) {
        if (Test-Path $file) {
            $SpecFile = $file
            break
        }
    }

    if (-not $SpecFile) {
        Write-Error "错误: 无法找到规格文件，请指定文件路径"
        exit 1
    }
}

# 验证规格文件存在
if (-not (Test-Path $SpecFile)) {
    Write-Error "错误: 规格文件不存在: $SpecFile"
    exit 1
}

function Write-Log {
    param([string]$Message)
    if ($Verbose) {
        Write-Host "[INFO] $Message"
    }
}

Write-Log "开始验证规格文件: $SpecFile"
Write-Log "验证范围: $Scope"

# 初始化检查结果
$script:MissingSections = @()
$script:Warnings = @()
$script:Errors = @()
$script:CompletionScore = 0
$script:TotalChecks = 0

# 检查必要章节的函数
function Test-Section {
    param(
        [string]$Section,
        [string]$Category,
        [int]$Weight = 1
    )

    $script:TotalChecks += $Weight

    $content = Get-Content $SpecFile -Raw
    if ($content -match "## $Section") {
        $script:CompletionScore += $Weight
        Write-Log "✓ 找到章节: $Section"
    } else {
        $script:MissingSections += "$Category`:$Section"
        Write-Log "✗ 缺失章节: $Section"
    }
}

# 检查内容质量的函数
function Test-ContentQuality {
    param(
        [string]$Pattern,
        [string]$Description,
        [string]$Category,
        [int]$Weight = 1
    )

    $script:TotalChecks += $Weight

    $content = Get-Content $SpecFile -Raw
    if ($content -match $Pattern) {
        $script:CompletionScore += $Weight
        Write-Log "✓ $Description"
    } else {
        $script:Warnings += "$Category`:$Description"
        Write-Log "⚠ $Description"
    }
}

# 检查需求模糊性的函数
function Test-RequirementAmbiguity {
    param(
        [string]$Pattern,
        [string]$Description,
        [string]$Category
    )

    $content = Get-Content $SpecFile -Raw
    if ($content -match $Pattern) {
        $script:Errors += "$Category`:$Description"
        Write-Log "✗ 发现模糊需求: $Description"
    }
}

# 执行基础检查
Write-Host "🔍 执行基础完整性检查..."

Test-Section "用户场景和测试" "business" 2
Test-Section "需求" "business" 3
Test-Section "审查和验收检查清单" "quality" 1

# 根据范围执行详细检查
switch ($Scope) {
    "business" {
        Write-Host "🔍 执行业务需求检查..."
        Test-Section "业务背景和价值主张" "business" 2
        Test-Section "功能边界和排除项" "business" 1
        Test-Section "依赖和集成" "business" 1

        Test-ContentQuality "成功指标" "业务成功指标已定义" "business"
        Test-ContentQuality "目标用户" "目标用户群体已识别" "business"
    }
    "technical" {
        Write-Host "🔍 执行技术需求检查..."
        Test-Section "非功能性需求" "technical" 3
        Test-Section "关键实体" "technical" 1

        Test-ContentQuality "性能要求" "性能要求已量化" "technical"
        Test-ContentQuality "安全要求" "安全要求已定义" "technical"
        Test-ContentQuality "可用性要求" "可用性目标已明确" "technical"
    }
    "ux" {
        Write-Host "🔍 执行用户体验检查..."
        Test-Section "可访问性要求" "ux" 2

        Test-ContentQuality "用户界面" "用户界面已考虑" "ux"
        Test-ContentQuality "设备兼容" "设备兼容性已考虑" "ux"
    }
    "security" {
        Write-Host "🔍 执行安全需求检查..."
        Test-Section "数据和隐私要求" "security" 3

        Test-ContentQuality "数据加密" "数据加密要求已考虑" "security"
        Test-ContentQuality "访问控制" "访问控制已定义" "security"
        Test-ContentQuality "审计日志" "审计日志要求已明确" "security"
    }
    "all" {
        Write-Host "🔍 执行全面检查..."
        # 业务需求
        Test-Section "业务背景和价值主张" "business" 2
        Test-Section "功能边界和排除项" "business" 1
        Test-Section "依赖和集成" "business" 1
        Test-Section "非功能性需求" "technical" 3
        Test-Section "关键实体" "technical" 1
        Test-Section "数据和隐私要求" "security" 3
        Test-Section "可访问性要求" "ux" 2

        # 内容质量检查
        Test-ContentQuality "成功指标" "业务成功指标已定义" "business"
        Test-ContentQuality "目标用户" "目标用户群体已识别" "business"
        Test-ContentQuality "性能要求" "性能要求已量化" "technical"
        Test-ContentQuality "安全要求" "安全要求已定义" "security"
        Test-ContentQuality "可用性要求" "可用性目标已明确" "technical"
        Test-ContentQuality "数据加密" "数据加密要求已考虑" "security"
        Test-ContentQuality "访问控制" "访问控制已定义" "security"
        Test-ContentQuality "用户界面" "用户界面已考虑" "ux"
        Test-ContentQuality "设备兼容" "设备兼容性已考虑" "ux"
    }
}

# 检查需求模糊性
Write-Host "🔍 检查需求模糊性..."
Test-RequirementAmbiguity "\[需要澄清:" "存在未澄清的需求项" "quality"
Test-RequirementAmbiguity "\[TODO\]|\[待定\]" "存在待定项" "quality"
Test-RequirementAmbiguity "适当|合理|良好|优化" "存在模糊的描述词汇" "quality"

# 计算完成度百分比
if ($script:TotalChecks -gt 0) {
    $CompletionPercentage = [math]::Round(($script:CompletionScore * 100.0) / $script:TotalChecks, 0)
} else {
    $CompletionPercentage = 0
}

# 输出结果
Write-Host ""
Write-Host "📊 验证结果汇总"
Write-Host "=================="
Write-Host "规格文件: $SpecFile"
Write-Host "验证范围: $Scope"
Write-Host "完成度: $CompletionPercentage% ($script:CompletionScore/$script:TotalChecks)"
Write-Host ""

# 分类输出问题
if ($script:MissingSections.Count -gt 0) {
    Write-Host "❌ 缺失的重要章节:"
    foreach ($item in $script:MissingSections) {
        $parts = $item -split ':'
        $category = $parts[0]
        $section = $parts[1]
        Write-Host "   - $section (类别: $category)"
    }
    Write-Host ""
}

if ($script:Warnings.Count -gt 0) {
    Write-Host "⚠️  警告项:"
    foreach ($item in $script:Warnings) {
        $parts = $item -split ':'
        $category = $parts[0]
        $description = $parts[1]
        Write-Host "   - $description (类别: $category)"
    }
    Write-Host ""
}

if ($script:Errors.Count -gt 0) {
    Write-Host "🚫 错误项:"
    foreach ($item in $script:Errors) {
        $parts = $item -split ':'
        $category = $parts[0]
        $description = $parts[1]
        Write-Host "   - $description (类别: $category)"
    }
    Write-Host ""
}

# 提供改进建议
Write-Host "💡 改进建议:"
if ($script:MissingSections.Count -gt 0) {
    Write-Host "   1. 补充缺失的重要章节，特别是业务背景和需求定义"
}
if ($script:Warnings.Count -gt 0) {
    Write-Host "   2. 完善警告项中提到的内容，提高需求完整性"
}
if ($script:Errors.Count -gt 0) {
    Write-Host "   3. 解决模糊需求，明确所有[需要澄清]的项目"
}
Write-Host "   4. 运行 /clarify 命令进一步澄清需求细节"
Write-Host "   5. 参考需求完整性检查清单进行全面审查"

# 设置退出码
if ($script:Errors.Count -gt 0) {
    exit 1
} elseif ($script:Warnings.Count -gt 0 -or $script:MissingSections.Count -gt 0) {
    exit 2
} else {
    Write-Host "✅ 规格文件验证通过！"
    exit 0
}