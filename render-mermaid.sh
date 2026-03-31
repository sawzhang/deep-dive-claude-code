#!/bin/bash
# Extract mermaid code blocks, render to SVG, replace in markdown
set -e

INPUT="deep-dive-claude-code-full.md"
OUTPUT="deep-dive-claude-code-with-images.md"
SVG_DIR="mermaid-svgs"
mkdir -p "$SVG_DIR"

# Config for mmdc
cat > /tmp/mermaid-config.json << 'CONF'
{
  "theme": "default",
  "themeVariables": {
    "fontSize": "14px",
    "fontFamily": "PingFang SC, Helvetica, Arial, sans-serif"
  }
}
CONF

cp "$INPUT" "$OUTPUT"

# Extract each mermaid block, render, replace
idx=0
while IFS= read -r line_num; do
  idx=$((idx + 1))
  svg_file="$SVG_DIR/mermaid-${idx}.svg"

  # Extract the mermaid content between ```mermaid and ```
  start_line=$line_num
  # Find the closing ``` after this line
  end_line=$(tail -n +$((start_line + 1)) "$INPUT" | grep -n '^```$' | head -1 | cut -d: -f1)
  end_line=$((start_line + end_line))

  # Extract mermaid content (between start+1 and end-1)
  content_start=$((start_line + 1))
  content_end=$((end_line - 1))
  sed -n "${content_start},${content_end}p" "$INPUT" > "/tmp/mermaid-${idx}.mmd"

  # Render to SVG
  if mmdc -i "/tmp/mermaid-${idx}.mmd" -o "$svg_file" -c /tmp/mermaid-config.json -b transparent --quiet 2>/dev/null; then
    echo "OK: mermaid-${idx}.svg"
  else
    echo "FAIL: mermaid-${idx} (keeping as code block)"
    continue
  fi

done < <(grep -n '```mermaid' "$INPUT" | cut -d: -f1)

echo ""
echo "Rendered: $(ls $SVG_DIR/*.svg 2>/dev/null | wc -l | tr -d ' ') / $idx total"

# Now replace mermaid blocks with image references in the output
# Process in reverse order to preserve line numbers
python3 << 'PYEOF'
import re, os

with open("deep-dive-claude-code-full.md", "r") as f:
    content = f.read()

idx = 0
def replace_mermaid(match):
    global idx
    idx += 1
    svg_path = f"mermaid-svgs/mermaid-{idx}.svg"
    if os.path.exists(svg_path):
        return f"![diagram](mermaid-svgs/mermaid-{idx}.svg)"
    else:
        return match.group(0)  # keep original if SVG not found

result = re.sub(r'```mermaid\n(.*?)\n```', replace_mermaid, content, flags=re.DOTALL)

with open("deep-dive-claude-code-with-images.md", "w") as f:
    f.write(result)

print(f"Replaced {idx} mermaid blocks with SVG references")
PYEOF
