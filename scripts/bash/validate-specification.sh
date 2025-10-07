#!/usr/bin/env bash

set -euo pipefail

# 需求验证脚本
# 检查规格文件是否包含所有必要信息，识别潜在的需求遗漏

# 解析参数
VERBOSE=false
SPEC_FILE=""
SCOPE=""

show_help() {
    cat << EOF
需求验证脚本 - 检查规格完整性和识别需求遗漏

用法: $0 [选项] [规格文件路径]
选项:
  -v, --verbose           显示详细输出
  -s, --scope SCOPE       验证范围 (business|technical|ux|security|all)
  -h, --help              显示此帮助信息

示例:
  $0 specs/001-user-authentication/spec.md
  $0 -s business specs/001-user-authentication/spec.md
  $0 -v -s technical specs/001-user-authentication/spec.md
EOF
}

# 解析命令行参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--verbose)
            VERBOSE=true
            shift
            ;;
        -s|--scope)
            SCOPE="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        -*)
            echo "错误: 未知选项 $1" >&2
            show_help
            exit 1
            ;;
        *)
            SPEC_FILE="$1"
            shift
            ;;
    esac
done

# 设置默认值
if [[ -z "$SCOPE" ]]; then
    SCOPE="all"
fi

# 如果没有指定规格文件，尝试自动发现
if [[ -z "$SPEC_FILE" ]]; then
    # 获取当前分支
    CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "unknown")

    # 尝试找到规格文件
    POSSIBLE_FILES=(
        "specs/$CURRENT_BRANCH/spec.md"
        "specs/spec.md"
        "spec.md"
    )

    for file in "${POSSIBLE_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            SPEC_FILE="$file"
            break
        fi
    done

    if [[ -z "$SPEC_FILE" ]]; then
        echo "错误: 无法找到规格文件，请指定文件路径" >&2
        exit 1
    fi
fi

# 验证规格文件存在
if [[ ! -f "$SPEC_FILE" ]]; then
    echo "错误: 规格文件不存在: $SPEC_FILE" >&2
    exit 1
fi

log() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo "[INFO] $1"
    fi
}

log "开始验证规格文件: $SPEC_FILE"
log "验证范围: $SCOPE"

# 初始化检查结果
MISSING_SECTIONS=()
WARNINGS=()
ERRORS=()
COMPLETION_SCORE=0
TOTAL_CHECKS=0

# 检查必要章节的函数
check_section() {
    local section="$1"
    local category="$2"
    local weight="${3:-1}"

    TOTAL_CHECKS=$((TOTAL_CHECKS + weight))

    if grep -q "^## $section" "$SPEC_FILE"; then
        COMPLETION_SCORE=$((COMPLETION_SCORE + weight))
        log "✓ 找到章节: $section"
    else
        MISSING_SECTIONS+=("$category:$section")
        log "✗ 缺失章节: $section"
    fi
}

# 检查内容质量的函数
check_content_quality() {
    local pattern="$1"
    local description="$2"
    local category="$3"
    local weight="${4:-1}"

    TOTAL_CHECKS=$((TOTAL_CHECKS + weight))

    if grep -q "$pattern" "$SPEC_FILE"; then
        COMPLETION_SCORE=$((COMPLETION_SCORE + weight))
        log "✓ $description"
    else
        WARNINGS+=("$category:$description")
        log "⚠ $description"
    fi
}

# 检查需求模糊性的函数
check_requirement_ambiguity() {
    local pattern="$1"
    local description="$2"
    local category="$3"

    if grep -E "$pattern" "$SPEC_FILE"; then
        ERRORS+=("$category:$description")
        log "✗ 发现模糊需求: $description"
    fi
}

# 执行基础检查
echo "🔍 执行基础完整性检查..."

check_section "用户场景和测试" "business" 2
check_section "需求" "business" 3
check_section "审查和验收检查清单" "quality" 1

# 根据范围执行详细检查
case "$SCOPE" in
    "business")
        echo "🔍 执行业务需求检查..."
        check_section "业务背景和价值主张" "business" 2
        check_section "功能边界和排除项" "business" 1
        check_section "依赖和集成" "business" 1

        check_content_quality "成功指标" "业务成功指标已定义" "business"
        check_content_quality "目标用户" "目标用户群体已识别" "business"
        ;;
    "technical")
        echo "🔍 执行技术需求检查..."
        check_section "非功能性需求" "technical" 3
        check_section "关键实体" "technical" 1

        check_content_quality "性能要求" "性能要求已量化" "technical"
        check_content_quality "安全要求" "安全要求已定义" "technical"
        check_content_quality "可用性要求" "可用性目标已明确" "technical"
        ;;
    "ux")
        echo "🔍 执行用户体验检查..."
        check_section "可访问性要求" "ux" 2

        check_content_quality "用户界面" "用户界面已考虑" "ux"
        check_content_quality "设备兼容" "设备兼容性已考虑" "ux"
        ;;
    "security")
        echo "🔍 执行安全需求检查..."
        check_section "数据和隐私要求" "security" 3

        check_content_quality "数据加密" "数据加密要求已考虑" "security"
        check_content_quality "访问控制" "访问控制已定义" "security"
        check_content_quality "审计日志" "审计日志要求已明确" "security"
        ;;
    "all")
        echo "🔍 执行全面检查..."
        # 业务需求
        check_section "业务背景和价值主张" "business" 2
        check_section "功能边界和排除项" "business" 1
        check_section "依赖和集成" "business" 1
        check_section "非功能性需求" "technical" 3
        check_section "关键实体" "technical" 1
        check_section "数据和隐私要求" "security" 3
        check_section "可访问性要求" "ux" 2

        # 内容质量检查
        check_content_quality "成功指标" "业务成功指标已定义" "business"
        check_content_quality "目标用户" "目标用户群体已识别" "business"
        check_content_quality "性能要求" "性能要求已量化" "technical"
        check_content_quality "安全要求" "安全要求已定义" "security"
        check_content_quality "可用性要求" "可用性目标已明确" "technical"
        check_content_quality "数据加密" "数据加密要求已考虑" "security"
        check_content_quality "访问控制" "访问控制已定义" "security"
        check_content_quality "用户界面" "用户界面已考虑" "ux"
        check_content_quality "设备兼容" "设备兼容性已考虑" "ux"
        ;;
esac

# 检查需求模糊性
echo "🔍 检查需求模糊性..."
check_requirement_ambiguity "\[需要澄清:" "存在未澄清的需求项" "quality"
check_requirement_ambiguity "\[TODO\]|\[待定\]" "存在待定项" "quality"
check_requirement_ambiguity "适当|合理|良好|优化" "存在模糊的描述词汇" "quality"

# 计算完成度百分比
if [[ $TOTAL_CHECKS -gt 0 ]]; then
    COMPLETION_PERCENTAGE=$((COMPLETION_SCORE * 100 / TOTAL_CHECKS))
else
    COMPLETION_PERCENTAGE=0
fi

# 输出结果
echo
echo "📊 验证结果汇总"
echo "=================="
echo "规格文件: $SPEC_FILE"
echo "验证范围: $SCOPE"
echo "完成度: $COMPLETION_PERCENTAGE% ($COMPLETION_SCORE/$TOTAL_CHECKS)"
echo

# 分类输出问题
if [[ ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    echo "❌ 缺失的重要章节:"
    for item in "${MISSING_SECTIONS[@]}"; do
        IFS=':' read -r category section <<< "$item"
        echo "   - $section (类别: $category)"
    done
    echo
fi

if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    echo "⚠️  警告项:"
    for item in "${WARNINGS[@]}"; do
        IFS=':' read -r category description <<< "$item"
        echo "   - $description (类别: $category)"
    done
    echo
fi

if [[ ${#ERRORS[@]} -gt 0 ]]; then
    echo "🚫 错误项:"
    for item in "${ERRORS[@]}"; do
        IFS=':' read -r category description <<< "$item"
        echo "   - $description (类别: $category)"
    done
    echo
fi

# 提供改进建议
echo "💡 改进建议:"
if [[ ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    echo "   1. 补充缺失的重要章节，特别是业务背景和需求定义"
fi
if [[ ${#WARNINGS[@]} -gt 0 ]]; then
    echo "   2. 完善警告项中提到的内容，提高需求完整性"
fi
if [[ ${#ERRORS[@]} -gt 0 ]]; then
    echo "   3. 解决模糊需求，明确所有[需要澄清]的项目"
fi
echo "   4. 运行 /clarify 命令进一步澄清需求细节"
echo "   5. 参考需求完整性检查清单进行全面审查"

# 设置退出码
if [[ ${#ERRORS[@]} -gt 0 ]]; then
    exit 1
elif [[ ${#WARNINGS[@]} -gt 0 || ${#MISSING_SECTIONS[@]} -gt 0 ]]; then
    exit 2
else
    echo "✅ 规格文件验证通过！"
    exit 0
fi