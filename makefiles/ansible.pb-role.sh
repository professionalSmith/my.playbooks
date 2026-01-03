#!/bin/bash

if [ -z "$1" ]; then
    echo "Role name cannot be empty."
    exit 1
fi

ROLE_DIRECTORY=roles/$1
if [ -d "$ROLE_DIRECTORY" ]; then
    echo "Role '$1' already exists."
    exit 1
fi

REQUIRED_SUB_DIRECTORIES="defaults tasks"
for directory in $REQUIRED_SUB_DIRECTORIES; do
    mkdir -p "$ROLE_DIRECTORY/$directory"
    touch "$ROLE_DIRECTORY/$directory/main.yaml"
done

OPTIONAL_SUB_DIRECTORIES="files handlers meta templates vars"
for directory in $OPTIONAL_SUB_DIRECTORIES; do
    DIR="$ROLE_DIRECTORY/$directory"
    read -rp "Create $DIR? [y/N]: " CONFIRM
    if [ "$CONFIRM" = "y" ] || [ "$CONFIRM" = "Y" ]; then
        mkdir -p "$DIR"
        touch "$ROLE_DIRECTORY/tasks/main.yaml"
    fi
done

DEFAULTS_FILE_BODY=$(cat <<EOF
applications:
  - name:
    packages:
      homebrew:
    tags:
      -
EOF
)
echo "$DEFAULTS_FILE_BODY" > "$ROLE_DIRECTORY/defaults/main.yaml"

TASKS_MAIN_FILE_BODY=$(cat <<EOF
- name: Run tasks of $1 role (macOS).
  when: ansible_facts['os_family'] == "Darwin"
  include_tasks: macos.yaml
EOF
)
echo "$TASKS_MAIN_FILE_BODY" > "$ROLE_DIRECTORY/tasks/main.yaml"

TASKS_MACOS_FILE_BODY=$(cat <<EOF
- name: Install applications of $1 role (macOS).
  homebrew:
    name: "{{ app.packages.homebrew }}"
    state: present
  loop: "{{ applications }}"
  loop_control:
    loop_var: app
EOF
)
echo "$TASKS_MACOS_FILE_BODY" > "$ROLE_DIRECTORY/tasks/macos.yaml"

echo "Created Ansible role: $ROLE_DIRECTORY"
