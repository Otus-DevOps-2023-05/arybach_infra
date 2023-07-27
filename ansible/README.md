inventory file contents:
appserver ansible_host=158.160.106.176 ansible_user=ubuntu ansible_private_key_file=/home/groot/.ssh/tumblebuns

or, if saved as inventory.yml:
appserver:
  ansible_host: 158.160.106.176
  ansible_user: ubuntu
  ansible_private_key_file: ~/.ssh/tumblebuns

[4] % ansible appserver -i ./inventory -m ping
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

adding db server to inventory file:
[app_servers]
appserverApp ansible_host=158.160.106.176 ansible_user=ubuntu ansible_private_key_file=/home/groot/.ssh/tumblebuns
appserverDb ansible_host=158.160.113.21 ansible_user=ubuntu ansible_private_key_file=/home/groot/.ssh/tumblebuns

[0] % ansible app_servers -i ./inventory -m ping
appserverDb | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
appserverApp | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

added ainsible.cfg file:
[defaults]
inventory = ./inventory
remote_user = ubuntu
private_key_file = ~/.ssh/tumblebuns
host_key_checking = False
retry_files_enabled = False

modified inventory file to:
[app_servers]
appserver ansible_host=158.160.106.176
dbserver ansible_host=158.160.113.21

checking...
[0] % ansible dbserver -m command -a uptime
dbserver | CHANGED | rc=0 >>
 07:56:34 up 15 min,  1 user,  load average: 0.00, 0.01, 0.00

split servers into groups (inventory file)):
[app]
appserver ansible_host=158.160.106.176

[db]
dbserver ansible_host=158.160.113.21

testing...
[0] % ansible app -m ping
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

created inventory.yml file:
app:
  hosts:
    appserver:
      ansible_host: 158.160.106.176
      # ansible_user: ubuntu
      # ansible_private_key_file: ~/.ssh/tumblebuns

db:
  hosts:
    dbserver:
      ansible_host: 158.160.113.21
      # ansible_user: ubuntu
      # ansible_private_key_file: ~/.ssh/tumblebuns

testing...
[0] % ansible all -m ping -i inventory.yml
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
appserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}

checking packer-installed apps...
[0] % ansible app -m command -a 'ruby -v'
appserver | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]

[0] % ansible app -m command -a 'bundler -v'
appserver | CHANGED | rc=0 >>
Bundler version 1.11.2

and both...
[0] % ansible app -m shell -a 'ruby -v; bundler -v'
appserver | CHANGED | rc=0 >>
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
Bundler version 1.11.2

checking mongoDb...
[2] % ansible db -m command -a 'systemctl status mongod'
or
[0] % ansible db -m shell -a 'systemctl status mongod'
''' the output is the same in both cases:
dbserver | CHANGED | rc=0 >>
● mongod.service - MongoDB Database Server
   Loaded: loaded (/lib/systemd/system/mongod.service; enabled; vendor preset: enabled)
   Active: active (running) since Mon 2023-07-24 07:41:46 UTC; 31min ago
     Docs: https://docs.mongodb.org/manual
 Main PID: 651 (mongod)
   CGroup: /system.slice/mongod.service
           └─651 /usr/bin/mongod --config /etc/mongod.conf

Jul 24 07:41:46 fhmc09svn9jkee2kn9t8 systemd[1]: Started MongoDB Database Server.

and the long output:
[0] % ansible db -m systemd -a name=mongod
or
ansible db -m service -a name=mongod
''' the output is the same in both cases:
dbserver | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "name": "mongod",
    "status": {
        "ActiveEnterTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "ActiveEnterTimestampMonotonic": "14053203",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "active",
        "After": "system.slice sysinit.target systemd-journald.socket network.target basic.target",
        "AllowIsolate": "no",
        "AmbientCapabilities": "0",
        "AssertResult": "yes",
        "AssertTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "AssertTimestampMonotonic": "14052574",
        "Before": "multi-user.target shutdown.target",
        "BlockIOAccounting": "no",
        "BlockIOWeight": "18446744073709551615",
        "CPUAccounting": "no",
        "CPUQuotaPerSecUSec": "infinity",
        "CPUSchedulingPolicy": "0",
        "CPUSchedulingPriority": "0",
        "CPUSchedulingResetOnFork": "no",
        "CPUShares": "18446744073709551615",
        "CPUUsageNSec": "18446744073709551615",
        "CanIsolate": "no",
        "CanReload": "no",
        "CanStart": "yes",
        "CanStop": "yes",
        "CapabilityBoundingSet": "18446744073709551615",
        "ConditionResult": "yes",
        "ConditionTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "ConditionTimestampMonotonic": "14052574",
        "Conflicts": "shutdown.target",
        "ControlGroup": "/system.slice/mongod.service",
        "ControlPID": "0",
        "DefaultDependencies": "yes",
        "Delegate": "no",
        "Description": "MongoDB Database Server",
        "DevicePolicy": "auto",
        "Documentation": "https://docs.mongodb.org/manual",
        "EnvironmentFile": "/etc/default/mongod (ignore_errors=yes)",
        "ExecMainCode": "0",
        "ExecMainExitTimestampMonotonic": "0",
        "ExecMainPID": "651",
        "ExecMainStartTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "ExecMainStartTimestampMonotonic": "14053165",
        "ExecMainStatus": "0",
        "ExecStart": "{ path=/usr/bin/mongod ; argv[]=/usr/bin/mongod --config /etc/mongod.conf ; ignore_errors=no ; start_time=[Mon 2023-07-24 07:41:46 UTC] ; stop_time=[n/a] ; pid=651 ; code=(null) ; status=0/0 }",
        "FailureAction": "none",
        "FileDescriptorStoreMax": "0",
        "FragmentPath": "/lib/systemd/system/mongod.service",
        "Group": "mongodb",
        "GuessMainPID": "yes",
        "IOScheduling": "0",
        "Id": "mongod.service",
        "IgnoreOnIsolate": "no",
        "IgnoreSIGPIPE": "yes",
        "InactiveEnterTimestampMonotonic": "0",
        "InactiveExitTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "InactiveExitTimestampMonotonic": "14053203",
        "JobTimeoutAction": "none",
        "JobTimeoutUSec": "infinity",
        "KillMode": "control-group",
        "KillSignal": "15",
        "LimitAS": "18446744073709551615",
        "LimitASSoft": "18446744073709551615",
        "LimitCORE": "18446744073709551615",
        "LimitCORESoft": "0",
        "LimitCPU": "18446744073709551615",
        "LimitCPUSoft": "18446744073709551615",
        "LimitDATA": "18446744073709551615",
        "LimitDATASoft": "18446744073709551615",
        "LimitFSIZE": "18446744073709551615",
        "LimitFSIZESoft": "18446744073709551615",
        "LimitLOCKS": "18446744073709551615",
        "LimitLOCKSSoft": "18446744073709551615",
        "LimitMEMLOCK": "18446744073709551615",
        "LimitMEMLOCKSoft": "18446744073709551615",
        "LimitMSGQUEUE": "819200",
        "LimitMSGQUEUESoft": "819200",
        "LimitNICE": "0",
        "LimitNICESoft": "0",
        "LimitNOFILE": "64000",
        "LimitNOFILESoft": "64000",
        "LimitNPROC": "64000",
        "LimitNPROCSoft": "64000",
        "LimitRSS": "18446744073709551615",
        "LimitRSSSoft": "18446744073709551615",
        "LimitRTPRIO": "0",
        "LimitRTPRIOSoft": "0",
        "LimitRTTIME": "18446744073709551615",
        "LimitRTTIMESoft": "18446744073709551615",
        "LimitSIGPENDING": "7846",
        "LimitSIGPENDINGSoft": "7846",
        "LimitSTACK": "18446744073709551615",
        "LimitSTACKSoft": "8388608",
        "LoadState": "loaded",
        "MainPID": "651",
        "MemoryAccounting": "no",
        "MemoryCurrent": "18446744073709551615",
        "MemoryLimit": "18446744073709551615",
        "MountFlags": "0",
        "NFileDescriptorStore": "0",
        "Names": "mongod.service",
        "NeedDaemonReload": "no",
        "Nice": "0",
        "NoNewPrivileges": "no",
        "NonBlocking": "no",
        "NotifyAccess": "none",
        "OOMScoreAdjust": "0",
        "OnFailureJobMode": "replace",
        "PIDFile": "/var/run/mongodb/mongod.pid",
        "PermissionsStartOnly": "no",
        "PrivateDevices": "no",
        "PrivateNetwork": "no",
        "PrivateTmp": "no",
        "ProtectHome": "no",
        "ProtectSystem": "no",
        "RefuseManualStart": "no",
        "RefuseManualStop": "no",
        "RemainAfterExit": "no",
        "Requires": "sysinit.target system.slice",
        "Restart": "no",
        "RestartUSec": "100ms",
        "Result": "success",
        "RootDirectoryStartOnly": "no",
        "RuntimeDirectoryMode": "0755",
        "RuntimeMaxUSec": "infinity",
        "SameProcessGroup": "no",
        "SecureBits": "0",
        "SendSIGHUP": "no",
        "SendSIGKILL": "yes",
        "Slice": "system.slice",
        "StandardError": "inherit",
        "StandardInput": "null",
        "StandardOutput": "journal",
        "StartLimitAction": "none",
        "StartLimitBurst": "5",
        "StartLimitInterval": "10000000",
        "StartupBlockIOWeight": "18446744073709551615",
        "StartupCPUShares": "18446744073709551615",
        "StateChangeTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "StateChangeTimestampMonotonic": "14053203",
        "StatusErrno": "0",
        "StopWhenUnneeded": "no",
        "SubState": "running",
        "SyslogFacility": "3",
        "SyslogLevel": "6",
        "SyslogLevelPrefix": "yes",
        "SyslogPriority": "30",
        "SystemCallErrorNumber": "0",
        "TTYReset": "no",
        "TTYVHangup": "no",
        "TTYVTDisallocate": "no",
        "TasksAccounting": "no",
        "TasksCurrent": "18446744073709551615",
        "TasksMax": "18446744073709551615",
        "TimeoutStartUSec": "1min 30s",
        "TimeoutStopUSec": "1min 30s",
        "TimerSlackNSec": "50000",
        "Transient": "no",
        "Type": "simple",
        "UMask": "0022",
        "UnitFilePreset": "enabled",
        "UnitFileState": "enabled",
        "User": "mongodb",
        "UtmpMode": "init",
        "WantedBy": "multi-user.target",
        "WatchdogTimestamp": "Mon 2023-07-24 07:41:46 UTC",
        "WatchdogTimestampMonotonic": "14053201",
        "WatchdogUSec": "0"
    }
}

trying...
ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
fails - no module git...

ansible app -m apt -a 'name=git state=present'
fails - permissions...

[2] % ansible app -m apt -a 'name=git state=present' --become
appserver | CHANGED => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "cache_update_time": 1689479539,
    "cache_updated": false,
    "changed": true,
    "stderr": "",
    "stderr_lines": [],
    "stdout": "Reading package lists...\nBuilding dependency tree...\nReading state information...\nThe following additional packages will be installed:\n  git-man liberror-perl rsync\nSuggested packages:\n  git-daemon-run | git-daemon-sysvinit git-doc git-el git-email git-gui gitk\n  gitweb git-arch git-cvs git-mediawiki git-svn\nThe following NEW packages will be installed:\n  git git-man liberror-perl rsync\n0 upgraded, 4 newly installed, 0 to remove and 8 not upgraded.\nNeed to get 4268 kB of archives.\nAfter this operation, 26.4 MB of additional disk space will be used.\nGet:1 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 rsync amd64 3.1.1-3ubuntu1.3 [329 kB]\nGet:2 http://mirror.yandex.ru/ubuntu xenial/main amd64 liberror-perl all 0.17-1.2 [19.6 kB]\nGet:3 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 git-man all 1:2.7.4-0ubuntu1.10 [737 kB]\nGet:4 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 git amd64 1:2.7.4-0ubuntu1.10 [3183 kB]\nFetched 4268 kB in 0s (8833 kB/s)\nSelecting previously unselected package rsync.\r\n(Reading database ... \r(Reading database ... 5%\r(Reading database ... 10%\r(Reading database ... 15%\r(Reading database ... 20%\r(Reading database ... 25%\r(Reading database ... 30%\r(Reading database ... 35%\r(Reading database ... 40%\r(Reading database ... 45%\r(Reading database ... 50%\r(Reading database ... 55%\r(Reading database ... 60%\r(Reading database ... 65%\r(Reading database ... 70%\r(Reading database ... 75%\r(Reading database ... 80%\r(Reading database ... 85%\r(Reading database ... 90%\r(Reading database ... 95%\r(Reading database ... 100%\r(Reading database ... 81130 files and directories currently installed.)\r\nPreparing to unpack .../rsync_3.1.1-3ubuntu1.3_amd64.deb ...\r\nUnpacking rsync (3.1.1-3ubuntu1.3) ...\r\nSelecting previously unselected package liberror-perl.\r\nPreparing to unpack .../liberror-perl_0.17-1.2_all.deb ...\r\nUnpacking liberror-perl (0.17-1.2) ...\r\nSelecting previously unselected package git-man.\r\nPreparing to unpack .../git-man_1%3a2.7.4-0ubuntu1.10_all.deb ...\r\nUnpacking git-man (1:2.7.4-0ubuntu1.10) ...\r\nSelecting previously unselected package git.\r\nPreparing to unpack .../git_1%3a2.7.4-0ubuntu1.10_amd64.deb ...\r\nUnpacking git (1:2.7.4-0ubuntu1.10) ...\r\nProcessing triggers for systemd (229-4ubuntu21.31) ...\r\nProcessing triggers for ureadahead (0.100.0-19.1) ...\r\nSetting up rsync (3.1.1-3ubuntu1.3) ...\r\nSetting up liberror-perl (0.17-1.2) ...\r\nSetting up git-man (1:2.7.4-0ubuntu1.10) ...\r\nSetting up git (1:2.7.4-0ubuntu1.10) ...\r\nProcessing triggers for systemd (229-4ubuntu21.31) ...\r\nProcessing triggers for ureadahead (0.100.0-19.1) ...\r\n",
    "stdout_lines": [
        "Reading package lists...",
        "Building dependency tree...",
        "Reading state information...",
        "The following additional packages will be installed:",
        "  git-man liberror-perl rsync",
        "Suggested packages:",
        "  git-daemon-run | git-daemon-sysvinit git-doc git-el git-email git-gui gitk",
        "  gitweb git-arch git-cvs git-mediawiki git-svn",
        "The following NEW packages will be installed:",
        "  git git-man liberror-perl rsync",
        "0 upgraded, 4 newly installed, 0 to remove and 8 not upgraded.",
        "Need to get 4268 kB of archives.",
        "After this operation, 26.4 MB of additional disk space will be used.",
        "Get:1 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 rsync amd64 3.1.1-3ubuntu1.3 [329 kB]",
        "Get:2 http://mirror.yandex.ru/ubuntu xenial/main amd64 liberror-perl all 0.17-1.2 [19.6 kB]",
        "Get:3 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 git-man all 1:2.7.4-0ubuntu1.10 [737 kB]",
        "Get:4 http://mirror.yandex.ru/ubuntu xenial-updates/main amd64 git amd64 1:2.7.4-0ubuntu1.10 [3183 kB]",
        "Fetched 4268 kB in 0s (8833 kB/s)",
        "Selecting previously unselected package rsync.",
        "(Reading database ... ",
        "(Reading database ... 5%",
        "(Reading database ... 10%",
        "(Reading database ... 15%",
        "(Reading database ... 20%",
        "(Reading database ... 25%",
        "(Reading database ... 30%",
        "(Reading database ... 35%",
        "(Reading database ... 40%",
        "(Reading database ... 45%",
        "(Reading database ... 50%",
        "(Reading database ... 55%",
        "(Reading database ... 60%",
        "(Reading database ... 65%",
        "(Reading database ... 70%",
        "(Reading database ... 75%",
        "(Reading database ... 80%",
        "(Reading database ... 85%",
        "(Reading database ... 90%",
        "(Reading database ... 95%",
        "(Reading database ... 100%",
        "(Reading database ... 81130 files and directories currently installed.)",
        "Preparing to unpack .../rsync_3.1.1-3ubuntu1.3_amd64.deb ...",
        "Unpacking rsync (3.1.1-3ubuntu1.3) ...",
        "Selecting previously unselected package liberror-perl.",
        "Preparing to unpack .../liberror-perl_0.17-1.2_all.deb ...",
        "Unpacking liberror-perl (0.17-1.2) ...",
        "Selecting previously unselected package git-man.",
        "Preparing to unpack .../git-man_1%3a2.7.4-0ubuntu1.10_all.deb ...",
        "Unpacking git-man (1:2.7.4-0ubuntu1.10) ...",
        "Selecting previously unselected package git.",
        "Preparing to unpack .../git_1%3a2.7.4-0ubuntu1.10_amd64.deb ...",
        "Unpacking git (1:2.7.4-0ubuntu1.10) ...",
        "Processing triggers for systemd (229-4ubuntu21.31) ...",
        "Processing triggers for ureadahead (0.100.0-19.1) ...",
        "Setting up rsync (3.1.1-3ubuntu1.3) ...",
        "Setting up liberror-perl (0.17-1.2) ...",
        "Setting up git-man (1:2.7.4-0ubuntu1.10) ...",
        "Setting up git (1:2.7.4-0ubuntu1.10) ...",
        "Processing triggers for systemd (229-4ubuntu21.31) ...",
        "Processing triggers for ureadahead (0.100.0-19.1) ..."
    ]
}

retrying...
[0] % ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
appserver | CHANGED => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "before": null,
    "changed": true
}
and then again to see no changes...
[0] % ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
appserver | SUCCESS => {
    "after": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "before": "5c217c565c1122c5343dc0514c116ae816c17ca2",
    "changed": false,
    "remote_url_changed": false
}

now with command module ...
[2] % ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/ubuntu/reddit'
appserver | FAILED | rc=128 >>
fatal: destination path '/home/ubuntu/reddit' already exists and is not an empty directory.non-zero return code

created playbook clone.yml:
- name: Clone
  hosts: app
  tasks:
    - name: Clone repo
      git:
        repo: https://github.com/express42/reddit.git
        dest: /home/ubuntu/reddit

checking...
[2] % ansible-playbook clone.yml

PLAY [Clone] ******************************************************************************************************************************************

TASK [Gathering Facts] ********************************************************************************************************************************
ok: [appserver]

TASK [Clone repo] *************************************************************************************************************************************
ok: [appserver]

PLAY RECAP ********************************************************************************************************************************************
appserver                  : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

removing reddit dir...
[0] % ansible app -m command -a 'rm -rf ~/reddit'
appserver | CHANGED | rc=0 >>


create statis inventory.json file:
{
    "app": {
        "hosts": ["appserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    },
    "db": {
        "hosts": ["dbserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    }
}

to trun it into dynamic inventory file add dynamic.py file which can generate new content for inventory.json file on the fly:
#!/usr/bin/env python3

import json

# Add code to generate dynamic inventory here

# Below is the static example
inventory = {
    "app": {
        "hosts": ["appserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    },
    "db": {
        "hosts": ["dbserver"],
        "vars": {
            "ansible_user": "ubuntu",
            "ansible_private_key_file": "/home/groot/.ssh/tumblebuns"
        }
    }
}

print(json.dumps(inventory))

chmod +x dynamic.py

and in ansible.cfg:
[defaults]
inventory = ./dynamic.py

Dynamic inventories are generated dynamically at runtime using executable scripts, static are hardcoded from the start.

'''Modifed terraform-2 repo to address test failures in ansible-1 branch
