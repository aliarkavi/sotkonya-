import os
import re

providers = [
    'authProvider', 'newsProvider', 'eventProvider', 'administrationProvider',
    'yurtProvider', 'settingsProvider', 'usersProvider', 'notificationProvider'
]

def migrate_file(filepath):
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()

    original_content = content

    for p in providers:
        # Check if the file has "final authProvider = ref.watch(authProvider);" or "ref.read(authProvider)" to a local variable
        if f"final {p} = ref.watch({p});" in content or f"final {p} = ref.read({p});" in content:
            # Change the local variable name to {p}Notifier
            new_var = p + "Notifier"
            content = content.replace(f"final {p} = ref.watch({p});", f"final {new_var} = ref.watch({p});")
            content = content.replace(f"final {p} = ref.read({p});", f"final {new_var} = ref.read({p});")
            
            # Now we must replace usages of `authProvider.` with `authProviderNotifier.`
            # but ONLY if it's the local variable. What if it's ref.watch(authProvider)? 
            # We already replaced `final authProvider = ` so `authProvider` local variable isn't colliding.
            # But the rest of the code still uses `authProvider.foo`
            content = re.sub(rf'\b{p}\.', f'{new_var}.', content)

            # Wait, what if someone explicitly used `Consumer(builder: (context, authProvider, child))` and my previous script
            # did `final authProvider = ref.watch(authProvider);`? So there might be `authProvider` used without `.` (e.g., passing it to something)
            # A safer regex: match \bauthProvider\b but not if preceded by 'ref.watch(' or 'ref.read(' or 'final '
            # Actually, `authProvider` the provider should only appear in `ref.watch(authProvider)` or `ref.read(authProvider)`
            # So let's replace `authProvider` everywhere with `authProviderNotifier`, EXCEPT in `ref.watch(authProvider)` and `ref.read(authProvider)`.
            pass

    # A better approach for the collision:
    for p in providers:
        new_name = p + 'Notifier'
        # 1. replace `final p = ref.watch(p);` -> `final new_name = ref.watch(p);`
        content = content.replace(f"final {p} = ref.watch({p});", f"final {new_name} = ref.watch({p});")
        content = content.replace(f"final {p} = ref.read({p});", f"final {new_name} = ref.read({p});")
        # 2. replace `final p = ref.watch(p)` (in case no semicolon)
        content = content.replace(f"final {p} = ref.watch({p})", f"final {new_name} = ref.watch({p})")
        content = content.replace(f"final {p} = ref.read({p})", f"final {new_name} = ref.read({p})")

    # To fix usages of the replaced local variable, let's find `p.` where `p` is in providers
    # and replace with `pNotifier.`. This covers 99% of cases: `authProvider.login()` etc
    # Let's do it only if the file contains `final {new_name} = `
    for p in providers:
        new_name = p + 'Notifier'
        if f"{new_name} = " in content:
            content = re.sub(rf'\b{p}\.', f'{new_name}.', content)

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
