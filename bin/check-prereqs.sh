#!/bin/sh
# ascii-armor prerequisite check
# Exit 0: all required tools present
# Exit 1: degraded (optional tools missing)
# Exit 2: broken (required tools missing)

REQUIRED="uuencode uudecode b64encode xxd git"
OPTIONAL="shar unshar compface uncompface convert ffmpeg"
PORTS="sharutils:shar graphics/compface:compface ImageMagick7:convert"

missing_required=0
missing_optional=0

check() {
  local tool="$1" req="$2"
  if command -v "$tool" >/dev/null 2>&1; then
    printf '{"tool":"%s","status":"ok","path":"%s"}\n' \
      "$tool" "$(command -v "$tool")"
  else
    printf '{"tool":"%s","status":"missing","required":%s}\n' \
      "$tool" "$req"
    [ "$req" = "true" ] && missing_required=$((missing_required+1)) \
                        || missing_optional=$((missing_optional+1))
  fi
}

echo '{"prereqs":['
for t in $REQUIRED; do check "$t" true;  done
for t in $OPTIONAL; do check "$t" false; done
echo ']}'

[ $missing_required -gt 0 ] && exit 2
[ $missing_optional -gt 0 ] && exit 1
exit 0
