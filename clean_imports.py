import os
import re

def remove_unused_imports(filepath, unused_list):
    if not os.path.exists(filepath):
        return
    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
        
    new_lines = []
    for i, line in enumerate(lines, 1):
        if i in unused_list:
            continue
        new_lines.append(line)
        
    with open(filepath, 'w', encoding='utf-8') as f:
        f.writelines(new_lines)

def main():
    # Read the analyze_output.txt
    if not os.path.exists('analyze_output.txt'):
        return
        
    with open('analyze_output.txt', 'r', encoding='utf-16') as f:
        lines = f.readlines()
        
    files_to_lines = {}
    for line in lines:
        if 'unused_import' in line:
            # line format example: warning - Unused import: '../providers/auth_provider.dart' - lib\auth_gate.dart:7:8 - unused_import
            parts = line.split('-')
            if len(parts) >= 3:
                # The file part is something like: lib\auth_gate.dart:7:8
                file_info = parts[-2].strip()
                # split by :
                info_parts = file_info.split(':')
                if len(info_parts) >= 3:
                    file_path = info_parts[0]
                    # On windows, it might have drive letter C:\
                    if len(info_parts) >= 4 and len(info_parts[0]) == 1: # C:\...
                        file_path = info_parts[0] + ':' + info_parts[1]
                        line_num = int(info_parts[2])
                    else:
                        line_num = int(info_parts[1])
                    
                    if file_path not in files_to_lines:
                        files_to_lines[file_path] = []
                    files_to_lines[file_path].append(line_num)
                    
    for file, unused in files_to_lines.items():
        remove_unused_imports(file, unused)
        print(f"Cleaned {file}")

if __name__ == '__main__':
    main()
