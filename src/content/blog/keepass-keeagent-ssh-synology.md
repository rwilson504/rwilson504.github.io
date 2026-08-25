---
title: "Passwordless SSH to Your Synology NAS Using KeePass and KeeAgent"
description: "Stop passing SSH passwords in plain text. Set up KeeAgent to serve SSH keys from your KeePass database so you can SSH into your Synology — and run sudo docker commands — without ever typing a password."
pubDate: 2026-08-25
category: dev-tools
tags:
  - synology
  - ssh
  - keepass
  - homelab
  - docker
  - security
  - self-hosted
draft: true
---

GitHub Copilot CLI can rebuild Docker containers on a Synology NAS over SSH, but embedding a password in the command would expose it in process arguments, shell history, and terminal output.

The fix: let KeePass handle SSH authentication through its **KeeAgent** plugin, and set up passwordless sudo for Docker on the Synology. The result is a single SSH command with no passwords anywhere.

## Bottom line

- Install the **KeeAgent** plugin for KeePass 2.x to turn your KeePass database into an SSH agent.
- Generate an Ed25519 SSH key, store it in a KeePass entry, and copy the public key to your Synology.
- Add a NOPASSWD sudoers rule for Docker on the Synology so `sudo docker` doesn't prompt either.
- Once configured, `ssh user@synology "sudo docker build ..."` just works — no passwords in commands, ever.

## Why this matters

When you automate SSH commands — whether through Copilot CLI, scripts, or CI — password-based authentication creates problems:

- **Passwords in command arguments** are visible in `ps` output and shell history.
- **Interactive password prompts** break automation and require workarounds like `sshpass` or `plink -pw`.
- **Sudo prompts** add a second password barrier even after SSH connects.
- **AI-assisted terminal sessions** can capture commands and output in prompts, transcripts, or tool context. A password included in either can become part of the AI session.

SSH key authentication avoids these problems. KeeAgent makes it practical by tying key availability to your KeePass database: open KeePass, keys are loaded; close KeePass, keys are gone.

This is not specific to Synology. Whether the SSH target is a NAS, Linux server, virtual machine, network appliance, or cloud host, credentials should never appear in commands or terminal output supplied to an AI assistant. Use an SSH agent or another credential mechanism that keeps secret material outside the session and performs authentication on your behalf.

## What you need

- **KeePass 2.52 or newer** — KeeAgent 0.13.8 requires KeePass 2.52 at minimum. I was on 2.38 and upgraded; the database format doesn't change unless you enable KDBX 4.x features, so older clients on other machines can still open the file.
- **KeeAgent plugin** — download from [lechnology.com/software/keeagent](https://lechnology.com/software/keeagent/). It supports RSA, DSA, ECDSA, and Ed25519 keys, works with both PuTTY and OpenSSH formats, and runs on Windows, Linux, and Mac.
- **Synology NAS** with SSH enabled.
- **Windows OpenSSH client** — ships with Windows 10/11.

## Step 1 — Generate an SSH key

Open a terminal and generate an Ed25519 key pair:

```powershell
ssh-keygen -t ed25519 -C "yourname-keepass" -f "$HOME\.ssh\id_synology"
```

You'll be prompted for a passphrase. Set one — KeeAgent will manage it for you, so you won't have to type it manually.

This creates two files:

- `~\.ssh\id_synology` — your private key (stays on your machine, goes into KeePass)
- `~\.ssh\id_synology.pub` — your public key (goes on the Synology)

## Step 2 — Install KeeAgent

1. Download `KeeAgent.plgx` from [lechnology.com/software/keeagent](https://lechnology.com/software/keeagent/).
2. Copy it into your KeePass plugins folder, typically:
   ```
   C:\Program Files\KeePass Password Safe 2\Plugins
   ```
3. Restart KeePass. You should see a new **KeeAgent** tab in entries and in **Tools → Options**.

## Step 3 — Add your SSH key to KeePass

1. Create a new entry in KeePass (e.g., title: **Synology SSH Key**).
2. Set the **Password** field to your key's passphrase.
3. Switch to the **KeeAgent** tab:
   - Check **"Allow KeeAgent to use this entry"**
   - Set the key location to **Attachment**
   - Click **Attach...** and select your private key file (`id_synology`) from your computer. KeeAgent automatically adds it to the entry's file attachments.
4. Save the entry.

## Step 4 — Configure KeeAgent as your SSH agent

1. In KeePass, go to **Tools → Options → KeeAgent** tab.
2. Check **"Enable agent for Windows OpenSSH (experimental)"**.
3. Disable the Windows SSH Agent service so it doesn't compete for the named pipe:

```powershell
Stop-Service ssh-agent
Set-Service ssh-agent -StartupType Disabled
```

> **Why disable the Windows ssh-agent?** Both KeeAgent and the Windows OpenSSH Agent listen on the same named pipe (`\\.\pipe\openssh-ssh-agent`). Only one process can own it. If the Windows service grabs it first, `ssh` talks to that agent (which has no keys) instead of KeeAgent. Disabling the service lets KeeAgent take over transparently.

4. Restart KeePass.
5. Verify the key is loaded:

```powershell
ssh-add -l
```

You should see your key fingerprint:

```
256 SHA256:xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx yourname-keepass (ED25519)
```

## Step 5 — Copy the public key to your Synology

```powershell
ssh-copy-id youruser@your-synology-ip
```

If `ssh-copy-id` isn't available on Windows, do it manually:

```powershell
$pubKey = Get-Content "$HOME\.ssh\id_synology.pub"
ssh youruser@your-synology-ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$pubKey' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

Make sure SSH is enabled on the Synology: **DSM → Control Panel → Terminal & SNMP → Enable SSH service**.

> **Security note:** It is generally best to leave SSH disabled on your Synology when you do not need remote shell access. Enable it for setup or maintenance, then turn it off again unless an ongoing automation workflow requires it.

Test it:

```powershell
ssh youruser@your-synology-ip "echo success"
```

That should connect without a password prompt. KeeAgent handles the key exchange in the background.

## Step 6 — Set up passwordless sudo for Docker

Even with SSH key auth, `sudo docker` still prompts for a password. Fix that with a targeted sudoers rule:

```bash
# On the Synology, via SSH
echo 'youruser ALL=(ALL) NOPASSWD: /usr/local/bin/docker' | sudo tee /etc/sudoers.d/docker
sudo chmod 440 /etc/sudoers.d/docker
```

This grants passwordless sudo **only** for the Docker binary — not for everything.

Test it:

```powershell
ssh youruser@your-synology-ip "sudo /usr/local/bin/docker --version"
```

Should return the Docker version with no password prompt.

## The payoff

Before, rebuilding a Docker container on the Synology looked like this — with the password visible in the command:

```powershell
# Don't do this
plink -ssh -batch user@synology -pw MyPassword "echo MyPassword | sudo -S docker build ..."
```

Now it's just:

```powershell
ssh youruser@your-synology-ip "cd /volume1/docker/openclaw && sudo docker build --pull -t openclaw-custom:latest ."
```

No passwords. No `sshpass`. No `-pw` flags. Works from GitHub Copilot CLI, from scripts, from CI runners — anywhere `ssh` can reach the agent.

## Multi-machine use

If you work across multiple machines, your KeePass database file is the key. Sync it however you already sync KeePass (OneDrive, Dropbox, network share, USB), install KeeAgent on each machine, and the same SSH key is available everywhere. Just make sure the Windows ssh-agent service is disabled on each machine so KeeAgent can take over the pipe.

You can also add the SSH key attachment to the KeePass entry once and it travels with the database — no need to copy `.ssh` key files between machines.

## Upgrading KeePass safely

If you're running an older version of KeePass 2.x (like I was on 2.38), you can upgrade safely:

- **New KeePass always opens old databases** — full backward compatibility.
- **The database format only changes if you enable KDBX 4.x features** (like Argon2 key derivation). If you don't change encryption settings, the file stays in the old format.
- **Old KeePass cannot open KDBX 4.x databases** — so upgrade all your machines before opting into new encryption features.

The safe approach: upgrade one machine at a time, don't touch encryption settings, and verify all machines can still open the database.

## Optional — SSH config for cleaner commands

Add an entry to `~\.ssh\config` to avoid typing the IP every time:

```
Host synology
    HostName 192.168.1.69
    User youruser
    IdentityFile ~/.ssh/id_synology
```

Then your commands become:

```powershell
ssh synology "cd /volume1/docker/openclaw && sudo docker build --pull -t openclaw-custom:latest ."
```

## Wrap-up

The combination of KeeAgent + SSH keys + NOPASSWD sudo turns what was a password-juggling exercise into a clean, automated workflow. KeePass manages the key lifecycle — open the database and your keys are available, lock it and they're gone. It's a small setup investment that pays off every time you SSH into the NAS.

## References

- [KeeAgent plugin for KeePass 2.x](https://lechnology.com/software/keeagent/) — SSH agent plugin, supports RSA/DSA/ECDSA/Ed25519, cross-platform
- [KeeAgent documentation](https://keeagent.readthedocs.io/en/latest/) — installation, configuration, and troubleshooting
- [KeeAgent source code on GitHub](https://github.com/dlech/KeeAgent)
- [KeePass 2.x](https://keepass.info/) — password manager
