# Search: grep/find vs rg/fd

rg and fd skip .gitignore'd and hidden files by default; add -uu to search everything.

## Text in files: grep -> rg
| Task                         | grep                          | rg                          |
|------------------------------|-------------------------------|-----------------------------|
| recursive, line numbers      | grep -rn foo .                | rg foo                      |
| ignore case                  | grep -rni foo .               | rg -i foo                   |
| whole word                   | grep -rnw foo .               | rg -w foo                   |
| fixed string (no regex)      | grep -rnF 'a.b' .             | rg -F 'a.b'                 |
| only file names              | grep -rl foo .                | rg -l foo                   |
| count per file               | grep -rc foo .                | rg -c foo                   |
| invert match                 | grep -rv foo .                | rg -v foo                   |
| context lines                | grep -rn -C3 foo .            | rg -C3 foo                  |
| only some files              | grep -rn --include='*.cpp' foo .  | rg -g '*.cpp' foo  /  rg -tcpp foo |
| exclude a dir                | grep -rn --exclude-dir=build foo . | rg -g '!build' foo     |
| include ignored/hidden       | (default)                     | rg -uu foo                  |
| replace in output only       | -                             | rg foo -r bar  (files untouched) |

careful: in rg, -r means --replace, not recursive (rg is always recursive).

## Files by name: find -> fd
| Task                         | find                               | fd                       |
|------------------------------|------------------------------------|--------------------------|
| name contains                | find . -name '*foo*'               | fd foo                   |
| by extension                 | find . -name '*.cpp'               | fd -e cpp                |
| exact glob                   | find . -name 'CMakeLists.txt'      | fd -g CMakeLists.txt     |
| files only / dirs only       | find . -type f / -type d           | fd -t f / fd -t d        |
| in a directory               | find src -name '*.h'               | fd -e h . src            |
| max depth                    | find . -maxdepth 2 -name foo       | fd -d 2 foo              |
| run a command on each        | find . -name '*.o' -exec rm {} +   | fd -e o -X rm            |
| changed in the last day      | find . -mtime -1                   | fd --changed-within 1d   |
| include ignored/hidden       | (default)                          | fd -uu foo               |

fd's pattern is a regex: fd '^main\.cpp$'. Use -g for a glob.
