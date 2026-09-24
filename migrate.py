import os
import re

def migrate_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    # 1. Fix `extends StatefulWidget` to `extends ConsumerStatefulWidget` for all widgets that have `ConsumerState`
    # Find all classes that have a corresponding ConsumerState
    # class _PromoSliderState extends ConsumerState<PromoSlider> -> PromoSlider should extend ConsumerStatefulWidget
    consumer_states = re.findall(r'class\s+\w+\s+extends\s+ConsumerState<(\w+)>', content)
    for widget_class in consumer_states:
        # replace `class X extends StatefulWidget` with `class X extends ConsumerStatefulWidget`
        content = re.sub(rf'class\s+{widget_class}\s+extends\s+StatefulWidget', rf'class {widget_class} extends ConsumerStatefulWidget', content)

    # 2. Fix `Widget build(BuildContext context, WidgetRef ref)` inside `ConsumerState`
    state_classes = re.findall(r'class\s+\w+\s+extends\s+ConsumerState<\w+>\s*{([^}]+)}', content)
    # Actually regex over state class body is hard due to nested brackets.
    # Let's just find `Widget build(BuildContext context, WidgetRef ref)` inside the whole file,
    # and if it belongs to a ConsumerState, change it. Actually, wait! StatefulWidgets don't have `WidgetRef ref` in the build method.
    # And ConsumerWidgets DO have it.
    # So if there's a ConsumerStatefulWidget, its state class is `ConsumerState`, and `build` should be `Widget build(BuildContext context)`
    # Let's fix ALL `Widget build(BuildContext context, WidgetRef ref)` that are inside a class extending `ConsumerState`.
    # A safer way:
    lines = content.split('\n')
    in_consumer_state = False
    for i, line in enumerate(lines):
        if re.search(r'class\s+\w+\s+extends\s+ConsumerState<\w+>', line):
            in_consumer_state = True
        elif re.search(r'class\s+\w+\s+extends\s+(ConsumerWidget|StatelessWidget)', line):
            in_consumer_state = False
            
        if in_consumer_state:
            if 'Widget build(BuildContext context, WidgetRef ref)' in line:
                lines[i] = line.replace('Widget build(BuildContext context, WidgetRef ref)', 'Widget build(BuildContext context)')
    content = '\n'.join(lines)

    # 3. Handle Provider.of<X>(context) missing replacements
    providers = [
        'AuthProvider', 'NewsProvider', 'EventProvider', 'AdministrationProvider',
        'YurtProvider', 'SettingsProvider', 'UsersProvider', 'NotificationProvider'
    ]
    
    def camel_case(s):
        return s[0].lower() + s[1:]

    for p in providers:
        cname = camel_case(p)
        content = content.replace(f'Provider.of<{p}>(context, listen: false)', f'ref.read({cname})')
        content = content.replace(f'Provider.of<{p}>(context)', f'ref.watch({cname})')
        content = content.replace(f'context.read<{p}>()', f'ref.read({cname})')
        content = content.replace(f'context.watch<{p}>()', f'ref.watch({cname})')

    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
            print(f"Updated {filepath}")

def main():
    for root, dirs, files in os.walk('lib'):
        for file in files:
            if file.endswith('.dart'):
                migrate_file(os.path.join(root, file))

if __name__ == '__main__':
    main()
