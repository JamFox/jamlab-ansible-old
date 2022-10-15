# JamLab Ansible Management

Ansible playbooks for configuration management in pull mode.

## Host inventory

Each host should belong to **ONE AND ONLY ONE** group.

To create a new playbook copy it from another one and change the list of roles in the file `local.yml`.

## Variable precedence

Variable precedence is as follows (from the weakest to the strongest):
1. role defaults (`rrr/defaults/main.yml`)
2. group vars (`playbooks/ppp/group_vars/all.yml`)
3. host vars (`playbooks/ppp/host_vars/hhh.yml`)
4. ansible argument (`ansible-playbook --extra-vars "my_var=my_value" ...`)

## Combine group and host vars

After the announcement of deprecating `hash_behaviour=merge` option in Ansible it is no longer possible to conveniently combine dictionaries with same names in role, group and host variables. 

When merging dictionaries the following convention should be followed:

For role defaults use the regular variable name `exampledict` in `rrr/defaults/main.yml`:
``yml
exampledict:
    - name: var1
``

For group defaults use the `group_` prefix with variable name `exampledict` in `playbooks/ppp/group_vars/all.yml`:
``yml
group_exampledict:
    - name: var2
``

For host defaults use the `host_` prefix with variable name `exampledict` in `playbooks/ppp/host_vars/hhh.yml`:
``yml
host_exampledict:
    - name: var3
``

## Playbook structure

Each playbook in `playbooks/`:
- has a name starting with:
  - `group_` (if it is applied to a group of machines)
  - `host_` (if it is applied to one host)
  - `function_` (if it is applied to a functionality).
- has a file named `local.yml` to describe the playbook with tasks and roles.
- may have a `group_vars/all.yml` to set the default values of variables for all hosts executing the playbook.
- may have a `host_vars/hhh.yml` to overwrite some variable values for that host `hhh` executing the playbook.
- does **NOT** have a role directory as it is outside of the playbook.
- does **NOT** have the `ansible.cfg` configuration file since it is one level upper.

Template structure of the playbooks:
```yml
playbooks/
  group_ggg/
    local.yml
    group_vars/
      all.yml
    host_vars/
      hhh.yml
  host_hhh/
    local.yml
    group_vars/
      all.yml
  function_fff/
    local.yml
```
The playbook of a host may be completely defined in `playbooks/host_hhh/` or just adapted in `playbooks/group_ggg/host_vars/hhh.yml`

Template structure of playbook `playbook/ppp/local.yml`:

```yml
- name: PLAYBOOK FOR GROUP 'GGG'
  hosts: ggg

  roles:

  - { role: pre, tags: [ pre ], when: not (disabled_roles.pre | default(false)) }

  - { role: rrr, tags: [ rrr ], when: not (disabled_roles.rrr | default(false)) }

  - { role: post, tags: [ post ], when: not (disabled_roles.post | default(false)) }
```
It is possible to disable a role for  host `hhh` for example, by defining in `playbooks/group_ggg/host_vars/hhh.yml`:
```yml
disabled_roles:
  rrr: true
```
There are two special roles at the begining and at the end of the playbook: `pre` and `post`.
They are used to replace the list of common roles to execute before and after specific ones.

## Role structure

Each role in `roles/` can be used in any playbook in `playbooks/ppp/local.yml`.

Template structure of a role:

```yml
roles/
  rrr/
    defaults/
    files/
    libraries/
    tasks/
    templates/
    vars/
```

## Host access to this repository

Hosts pull directly from this repository.

## Naming conventions

- In Git, names are merged with a dash ('-'), such as jamlab-ansible. This is for historical reasons.
- In Ansible, names are merged with an underscore ('_'), such as group_vars or host_vars.
- In Linux, names are merged with a dash ('-'), such as NetworkManager-wait-online.service or system-auth.
