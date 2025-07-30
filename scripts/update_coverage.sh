#!/bin/bash

# Script to run tests with coverage and update README badge automatically
# Usage: ./scripts/update_coverage.sh

set -e

echo "🧪 Running Flutter tests with coverage..."
flutter test --coverage || {
  echo "❌ Tests failed. Checking if coverage file exists..."
  if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ No coverage file found. Exiting..."
    exit 1
  fi
  echo "⚠️  Tests failed but coverage file exists. Continuing with existing coverage..."
}

# Check if lcov is installed
if ! command -v lcov &> /dev/null; then
  echo "⚠️  lcov not found. Installing via brew..."
  if command -v brew &> /dev/null; then
    brew install lcov
  else
    echo "❌ Please install lcov manually: https://github.com/linux-test-project/lcov"
    echo "   On macOS: brew install lcov"
    echo "   On Ubuntu: sudo apt-get install lcov"
    exit 1
  fi
fi

echo "📊 Calculating coverage percentage..."

# Alternative method to calculate coverage if lcov summary fails
COVERAGE=$(lcov --summary coverage/lcov.info 2>&1 | grep -E "lines\.*: [0-9]+\.[0-9]+%" | grep -oE "[0-9]+\.[0-9]+")

# Fallback: Calculate manually from lcov.info file
if [ -z "$COVERAGE" ]; then
  echo "⚠️  Using fallback coverage calculation..."
  TOTAL_LINES=$(awk -F: '/^LF:/ {sum += $2} END {print sum}' coverage/lcov.info)
  COVERED_LINES=$(awk -F: '/^LH:/ {sum += $2} END {print sum}' coverage/lcov.info)
  
  if [ "$TOTAL_LINES" -gt 0 ]; then
    # Use awk for reliable decimal formatting
    COVERAGE=$(awk "BEGIN {printf \"%.1f\", $COVERED_LINES * 100 / $TOTAL_LINES}")
  else
    COVERAGE="0.0"
  fi
fi

if [ -z "$COVERAGE" ] || [ "$COVERAGE" = "0" ]; then
  echo "❌ Could not calculate coverage percentage"
  exit 1
fi

# Ensure COVERAGE uses dot as decimal separator (not comma)
COVERAGE=$(echo "$COVERAGE" | sed 's/,/./g')

# Format coverage to 1 decimal place
# COVERAGE is already formatted above

echo "📈 Coverage: ${COVERAGE}%"

# Determine badge color based on coverage thresholds
if (( $(echo "$COVERAGE >= 20" | bc -l) )); then
  COLOR="brightgreen"
  EMOJI="🟢"
elif (( $(echo "$COVERAGE >= 15" | bc -l) )); then
  COLOR="yellow" 
  EMOJI="🟡"
elif (( $(echo "$COVERAGE >= 10" | bc -l) )); then
  COLOR="orange"
  EMOJI="🟠"
else
  COLOR="red"
  EMOJI="🔴"
fi

echo "${EMOJI} Badge color: $COLOR"

# Create badge URL with proper URL encoding
BADGE_URL="https://img.shields.io/badge/coverage-${COVERAGE}%25-${COLOR}?style=for-the-badge"

echo "🔗 Badge URL: $BADGE_URL"

# Backup README.md before modification
cp README.md README.md.bak

# Update README.md with improved regex
if grep -q "!\[Test Coverage\]" README.md; then
  # Replace existing badge
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS - use different delimiter to avoid conflict with URLs
    sed -i '' "s#!\[Test Coverage\](https://img.shields.io/badge/coverage-[^)]*)*#![Test Coverage]($BADGE_URL)#g" README.md
  else
    # Linux
    sed -i "s#!\[Test Coverage\](https://img.shields.io/badge/coverage-[^)]*)*#![Test Coverage]($BADGE_URL)#g" README.md
  fi
  
  # Verify the change was made
  if grep -q "coverage-${COVERAGE}%" README.md; then
    echo "✅ Updated existing coverage badge in README.md"
    rm README.md.bak  # Remove backup on success
  else
    echo "❌ Failed to update badge. Restoring backup..."
    mv README.md.bak README.md
    exit 1
  fi
else
  echo "❌ No Test Coverage badge found in README.md"
  echo "💡 Add this line to your README.md:"
  echo "![Test Coverage]($BADGE_URL)"
  rm README.md.bak
  exit 1
fi

# Generate HTML report
echo "📋 Generating HTML coverage report..."
if command -v genhtml &> /dev/null; then
  genhtml coverage/lcov.info -o coverage/html --quiet 2>/dev/null || {
    echo "⚠️  HTML generation failed, but continuing..."
  }
  HTML_REPORT="coverage/html/index.html"
else
  echo "⚠️  genhtml not available. Skipping HTML report generation."
  HTML_REPORT="not available"
fi

echo ""
echo "🎉 Coverage badge updated successfully!"
echo "📊 Coverage: ${COVERAGE}%"
echo "🏷️  Badge Color: ${COLOR}"
echo "📄 HTML report: $HTML_REPORT"
echo ""

# Show coverage summary
echo "📈 Coverage by file (top 10):"
if command -v lcov &> /dev/null; then
  lcov --list coverage/lcov.info 2>/dev/null | head -15 || {
    echo "⚠️  Could not generate coverage list"
  }
else
  echo "⚠️  lcov not available for detailed coverage list"
fi

echo ""
echo "🔍 Current README badge line:"
grep "Test Coverage" README.md || echo "❌ Badge not found in README"

echo ""
echo "✨ Done! Your coverage badge is now up to date."
