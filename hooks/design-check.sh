#!/usr/bin/env bash
# beautify-flutter design tripwire check.
# Runs the mechanical anti-pattern greps over lib/. Prints findings; exits 0
# (advisory) so it never blocks — the findings are fed back to the agent.
#
# Use standalone:            ./hooks/design-check.sh [path-to-project]
# Or as a Claude Code hook:  see README "Enforcement" section.

ROOT="${1:-.}"
LIB="$ROOT/lib"
[ -d "$LIB" ] || { echo "design-check: no lib/ at $ROOT — skipping"; exit 0; }

found=0
check() { # $1 = label, $2 = grep -E pattern, $3 = exclude pattern (optional)
  local hits
  hits=$(grep -rnE "$2" "$LIB" --include="*.dart" 2>/dev/null | grep -vE "${3:-__none__}" | head -8)
  if [ -n "$hits" ]; then
    found=1
    echo "DESIGN-CHECK [$1]:"
    echo "$hits" | sed 's/^/  /'
  fi
}

check "inline hex color outside theme/"        "Color\(0x|Color\.fromARGB|Color\.fromRGBO" "theme/|tokens|\.g\.dart"
check "Colors.* palette access outside theme/" "Colors\.[a-z]"                             "theme/|tokens|Colors\.transparent|\.g\.dart"
check "inline numeric styling outside theme/"  "fontSize:\s*[0-9]|BorderRadius\.circular\(\s*[0-9]|EdgeInsets\.(all|symmetric|only)\(\s*[0-9]" "theme/|tokens|\.g\.dart"
check "tight heading leading (clips descenders)" "height:\s*(0\.[0-9]+|1\.0[0-9]?)\b"      "height:\s*1\.0[5-9]"
check "deprecated APIs"                        "MaterialStateProperty|surfaceVariant|textScaleFactor|withOpacity\(|CardTheme\(" ""
check "template leftovers"                     "deepPurple|debugShowCheckedModeBanner|flutter_application" ""
check "shrinkWrap list"                        "shrinkWrap: true" ""
check "designSize scaling (breaks budget phones)" "ScreenUtilInit|\.setSp\(|flutter_screenutil" ""
check "theme captured outside build"           "Theme\.of\(context\)" "" | grep -iE "initState|static" 2>/dev/null

if [ "$found" -eq 1 ]; then
  echo ""
  echo "design-check: findings above are leads, not verdicts — read each line before fixing."
  echo "Rules: SKILL.md write-time tripwires · reference/anti-patterns.md audit protocol."
else
  echo "design-check: clean."
fi
exit 0
