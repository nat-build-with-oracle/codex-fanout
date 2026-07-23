#!/usr/bin/env python3
"""Insert ZWSP at Thai word boundaries for proper line breaking."""
import sys, re
from pythainlp.tokenize import word_tokenize

ZWSP = "​"

def has_thai(text):
    return bool(re.search(r'[฀-๿]', text))

def insert_zwsp(text):
    if not has_thai(text):
        return text
    parts = re.split(r'(`[^`]+`)', text)  # preserve inline code
    result = []
    for part in parts:
        if part.startswith('`'):
            result.append(part)
        elif has_thai(part):
            segments = re.split(r'([฀-๿]+)', part)
            for seg in segments:
                if has_thai(seg):
                    result.append(ZWSP.join(word_tokenize(seg, engine="newmm")))
                else:
                    result.append(seg)
        else:
            result.append(part)
    return ''.join(result)

if __name__ == "__main__":
    path = sys.argv[1]
    with open(path, encoding="utf-8") as f:
        lines = f.readlines()
    out = []
    in_code = False
    for line in lines:
        if line.strip().startswith("```"):
            in_code = not in_code
            out.append(line)
            continue
        if in_code:
            out.append(line)
        else:
            out.append(insert_zwsp(line))
    sys.stdout.write("".join(out))
