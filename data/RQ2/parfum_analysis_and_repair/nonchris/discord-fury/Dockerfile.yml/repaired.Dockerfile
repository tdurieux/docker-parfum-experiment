---

- name: tasks
  hosts: localhost
  vars:
    - apt_packages:
      - python3
      - python3-pip
      - tzdata
    - pip3_packages:
        discord:
          name: discord.py
          version: 1.5.1
        psycopg2:
          name: psycopg2-binary
          version: 2.9.1
        SQLAlchemy:
          name: SQLAlchemy
          version: 1.4.20

  tasks:
  - name: Upgrade all packages to the latest version
    apt:
      update_cache: yes
      name: "*"
      state: latest

  - name: Remove useless packages from the cache
    apt:
      autoclean: yes

  - name: Remove dependencies that are no longer required
    apt:
      autoremove: yes

  - name: "Install packages defined in apt_packages"
    apt:
      name: "{{ item }}"
      state: latest
    loop: "{{ apt_packages }}"
    when: apt_packages|default([])|count > 0

  - name: "Install python pip requirements defined in pip3_packages"
    pip:
      executable: pip3
      name: "{{ item.value.name }}"
      version: "{{ item.value.version }}"
      state: forcereinstall
    loop: "{{ query('dict', pip3_packages) }}"
    when: pip3_packages|default([])|count > 0

  - name: 'collect files'
    find:
      paths: "/var/lib/apt/lists/"
      hidden: true
      recurse: true
    register: collected_files

  - name: 'collect directories'
    find:
      paths: "/var/lib/apt/lists/"
      hidden: true
      recurse: true
      file_type: directory
    register: collected_directories

  - name: remove collected files and directories
    file:
      path: "{{ item.path }}"
      state: absent
    with_items: >
      {{
        collected_files.files
        + collected_directories.files
      }}