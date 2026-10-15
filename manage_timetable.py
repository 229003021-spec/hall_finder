#!/usr/bin/env python3
"""
Hall Finder - Timetable Management Utility
------------------------------------------
This script allows you to easily export the current timetable to a human-readable 
JSON file ('timetable_data.json'), edit or replace it for a new semester, and pack 
it back into 'index.html' and 'web/index.html'.

Usage:
  1. Export current timetable to JSON:
     python manage_timetable.py export

  2. After editing or replacing 'timetable_data.json', re-pack and update the app:
     python manage_timetable.py apply
"""

import sys
import os
import re
import json
import base64

KEY = b"SASTRA_SRC_HALL_FINDER_SECURE_PAYLOAD_KEY_2026"
BASE_DIR = os.path.dirname(os.path.abspath(__file__))
INDEX_FILE = os.path.join(BASE_DIR, "index.html")
WEB_INDEX_FILE = os.path.join(BASE_DIR, "web", "index.html")
JSON_FILE = os.path.join(BASE_DIR, "timetable_data.json")

def decrypt_payload(payload_b64):
    raw_bytes = base64.b64decode(payload_b64)
    dec_bytes = bytes([b ^ KEY[i % len(KEY)] for i, b in enumerate(raw_bytes)])
    return json.loads(dec_bytes.decode("utf-8"))

def encrypt_payload(data_dict):
    json_bytes = json.dumps(data_dict, ensure_ascii=False, separators=(',', ':')).encode("utf-8")
    enc_bytes = bytes([b ^ KEY[i % len(KEY)] for i, b in enumerate(json_bytes)])
    return base64.b64encode(enc_bytes).decode("ascii")

def extract_payload_from_html(html_path):
    with open(html_path, "r", encoding="utf-8") as f:
        content = f.read()
    match = re.search(r'const _SECURE_PAYLOAD = "([^"]+)";', content)
    if not match:
        raise ValueError(f"Could not find const _SECURE_PAYLOAD in {html_path}")
    return match.group(1), content

def export_to_json():
    print(f"Reading from {INDEX_FILE}...")
    payload_b64, _ = extract_payload_from_html(INDEX_FILE)
    data = decrypt_payload(payload_b64)
    
    with open(JSON_FILE, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)
    
    print(f"[OK] Exported timetable successfully to: {JSON_FILE}")
    print(f"  * Course Names (CN): {len(data.get('CN', {}))} entries")
    print(f"  * Hall Info (HI):    {len(data.get('HI', {}))} rooms")
    print(f"  * Schedules (SCH):   {len(data.get('SCH', {}))} rooms scheduled")

def apply_from_json():
    if not os.path.exists(JSON_FILE):
        print(f"Error: {JSON_FILE} not found. Run 'python manage_timetable.py export' first.")
        sys.exit(1)
        
    print(f"Reading {JSON_FILE}...")
    with open(JSON_FILE, "r", encoding="utf-8") as f:
        data = json.load(f)
        
    for k in ["CN", "HI", "SCH"]:
        if k not in data:
            print(f"Error: Missing required section '{k}' in {JSON_FILE}.")
            sys.exit(1)
            
    print("Encrypting payload...")
    new_payload_b64 = encrypt_payload(data)
    
    def update_file(file_path):
        if not os.path.exists(file_path):
            print(f"Warning: {file_path} does not exist, skipping.")
            return
        with open(file_path, "r", encoding="utf-8") as f:
            content = f.read()
            
        pattern = r'const _SECURE_PAYLOAD = "[^"]+";'
        replacement = f'const _SECURE_PAYLOAD = "{new_payload_b64}";'
        
        if not re.search(pattern, content):
            raise ValueError(f"Could not find payload pattern in {file_path}")
            
        updated = re.sub(pattern, replacement, content, count=1)
        
        # Verify bracket balance
        counts = {b: 0 for b in '()[]{}'}
        for c in updated:
            if c in counts:
                counts[c] += 1
        if counts['('] != counts[')'] or counts['['] != counts[']'] or counts['{'] != counts['}']:
            raise ValueError(f"Bracket balance mismatch in {file_path}! {counts}")
            
        with open(file_path, "w", encoding="utf-8") as f:
            f.write(updated)
        print(f"[OK] Successfully updated: {file_path}")

    update_file(INDEX_FILE)
    update_file(WEB_INDEX_FILE)
    print("\n[OK] Both index.html and web/index.html have been updated!")
    print("  To deploy your changes, simply commit and push:")
    print("    git add index.html web/index.html timetable_data.json")
    print('    git commit -m "Update timetable for new semester"')
    print("    git push origin main")

if __name__ == "__main__":
    action = sys.argv[1].lower() if len(sys.argv) > 1 else "export"
    if action == "export":
        export_to_json()
    elif action in ["apply", "import"]:
        apply_from_json()
    else:
        print("Usage: python manage_timetable.py [export | apply]")
