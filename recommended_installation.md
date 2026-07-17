# Recommended Installation Guide & Linux System Maintenance
- [Recommended Installation Guide \& Linux System Maintenance](#recommended-installation-guide--linux-system-maintenance)
  - [Install Timeshift](#install-timeshift)
    - [Configure Timeshift Settings](#configure-timeshift-settings)
      - [Desktop (GUI)](#desktop-gui)
      - [Headless Server (CLI)](#headless-server-cli)
    - [Common Timeshift Commands](#common-timeshift-commands)
  - [Safely Updating \& Upgrading Linux OS](#safely-updating--upgrading-linux-os)
    - [Upgrade vs Full-Upgrade](#upgrade-vs-full-upgrade)
    - [Safe Upgrade Workflow](#safe-upgrade-workflow)
    - [When to Use Each Command](#when-to-use-each-command)
  - [Fixing Broken Packages \& Conflicts](#fixing-broken-packages--conflicts)
    - [Step 1: Identify Broken Packages](#step-1-identify-broken-packages)
    - [Step 2: Fix Conflicts](#step-2-fix-conflicts)
    - [Step 3: Clean \& Repair](#step-3-clean--repair)
    - [Step 4: Final Verification](#step-4-final-verification)
  - [Common Package Commands](#common-package-commands)
    - [Find Large Packages](#find-large-packages)
  - [Quick Reference Checklist](#quick-reference-checklist)

## Install Timeshift

```bash
sudo apt install timeshift
```

### Configure Timeshift Settings

#### Desktop (GUI)

1. **Launch Timeshift**: `sudo timeshift-gtk`
2. **Select Snapshot Type**: Choose **RSync** (more universal, works across filesystems)
3. **Configure Retention**:
   - **Boot snapshots**: Keep last 5-10
   - **Hourly snapshots**: Keep last 24
   - **Daily snapshots**: Keep last 7
   - **Weekly snapshots**: Keep last 4
   - **Monthly snapshots**: Keep last 3

#### Headless Server (CLI)

```bash
# Select RSync as snapshot type
sudo timeshift --rsync

# Create on-demand snapshot (use --scripted for cron/non-interactive)
sudo timeshift --create --comments "Pre-upgrade snapshot" --scripted

# Create with specific tag (B=Boot, H=Hourly, D=Daily, W=Weekly, M=Monthly, O=On-demand)
sudo timeshift --create --tags D --scripted

# List snapshots
sudo timeshift --list

# Run scheduled snapshot check (for cron)
sudo timeshift --check --scripted
```

**Retention policy** and excludes are configured in `/etc/timeshift/timeshift.json`:

```json
{
  "backup_device_uuid": "your-uuid-here",
  "btrfs_mode": "false",
  "do_first_run": "false",
  "stop_cron_emails": "true",
  "schedule_boot": "true",
  "schedule_hourly": "true",
  "schedule_daily": "true",
  "schedule_weekly": "true",
  "schedule_monthly": "true",
  "count_boot": "5",
  "count_hourly": "24",
  "count_daily": "7",
  "count_weekly": "4",
  "count_monthly": "3",
  "exclude": [
    "/root/**",
    "/home/**",
    "/var/cache/**",
    "/var/tmp/**",
    "/tmp/**",
    "/var/log/**"
  ],
  "exclude-apps": []
}
```

**Note**: By default Timeshift excludes `/root/**` and `/home/**` since it's a system restore tool, not a file backup tool. User files are excluded intentionally to keep snapshots small and avoid restoring stale personal data.

### Common Timeshift Commands

| Command                                                        | Description                             |
| -------------------------------------------------------------- | --------------------------------------- |
| `sudo timeshift --list`                                        | List all snapshots                      |
| `sudo timeshift --list --snapshot-device /dev/sdX`             | List snapshots on specific device       |
| `sudo timeshift --list-devices`                                | List available backup devices           |
| `sudo timeshift --create --comments "message"`                 | Create a snapshot                       |
| `sudo timeshift --create --comments "msg" --tags D --scripted` | Create daily snapshot (non-interactive) |
| `sudo timeshift --create --snapshot-device /dev/sdX`           | Create snapshot to specific device      |
| `sudo timeshift --restore`                                     | Restore a snapshot (interactive)        |
| `sudo timeshift --restore --snapshot <name>`                   | Restore specific snapshot               |
| `sudo timeshift --delete --snapshot <name>`                    | Delete a snapshot                       |
| `sudo timeshift --delete-all`                                  | Delete all snapshots                    |
| `sudo timeshift --rsync`                                       | Use RSync mode (default)                |
| `sudo timeshift --btrfs`                                       | Use BTRFS mode                          |
| `sudo timeshift-gtk`                                           | Launch GUI (desktop only)               |

---

## Safely Updating & Upgrading Linux OS

### Upgrade vs Full-Upgrade

| Command                       | Use When                                                  |
| ----------------------------- | --------------------------------------------------------- |
| `apt upgrade`                 | Safe updates, no package removals needed                  |
| `apt upgrade --with-new-pkgs` | Kernel or base packages require new dependencies          |
| `apt full-upgrade`            | Kernel upgrades, driver updates requiring package removal |
| `apt full-upgrade --dry-run`  | **Always preview before running**                         |

### Safe Upgrade Workflow

```bash
# 1. Always preview first
sudo apt full-upgrade --dry-run

# 2. Create Timeshift snapshot BEFORE upgrading
sudo timeshift --create --comments "Pre-$(date +%Y%m%d) upgrade"

# 3. Run the upgrade
sudo apt full-upgrade

# 4. Reboot if kernel was updated
sudo reboot
```

### When to Use Each Command

- **`upgrade --with-new-pkgs`**: When apt says new packages will be installed but refuses basic upgrade
- **`full-upgrade`**: When kernel, headers, or critical packages must be updated
- **`full-upgrade --dry-run`**: **Always** before `full-upgrade` to see what will change

---

## Fixing Broken Packages & Conflicts

### Step 1: Identify Broken Packages

```bash
sudo dpkg --configure -a
sudo apt --fix-broken install
```

### Step 2: Fix Conflicts

```bash
# Remove held/conflicting packages
sudo dpkg --remove <package-name>

# Force remove if absolutely necessary
sudo dpkg --force-remove-reinstreq <package-name>
```

### Step 3: Clean & Repair

```bash
sudo apt clean
sudo apt autoclean
sudo apt autoremove
sudo apt --fix-broken install
sudo apt update
```

### Step 4: Final Verification

```bash
sudo dpkg --audit
sudo apt-get check
```

---

## Common Package Commands

| Command                  | Description                           |
| ------------------------ | ------------------------------------- |
| `apt search <pkg>`       | Search for packages                   |
| `apt info <pkg>`         | Show package details                  |
| `apt list --installed`   | List all installed packages           |
| `apt list --installed    | grep <pkg>`                           | Find specific installed package |
| `dpkg -l                 | grep <pkg>`                           | Check if package is installed   |
| `apt show <pkg>`         | Show package metadata                 |
| `apt depends <pkg>`      | Show dependencies                     |
| `apt rdepends <pkg>`     | Show reverse dependencies             |
| `apt-mark showmanual`    | List manually installed packages      |
| `apt-mark showauto`      | List automatically installed packages |
| `apt autoremove`         | Remove orphaned packages              |
| `apt-cache policy <pkg>` | Show available versions               |

### Find Large Packages

```bash
dpkg-query -Wf '${Installed-Size}\t${Package}\n' | sort -n | tail -20
```

---

## Quick Reference Checklist

Before any major update:

- [ ] Run `sudo apt full-upgrade --dry-run` to preview
- [ ] Create Timeshift snapshot: `sudo timeshift --create --comments "Pre-upgrade"`
- [ ] Note any packages held back
- [ ] After upgrade, check for broken: `sudo apt --fix-broken install`
- [ ] Reboot if kernel changed
- [ ] Verify system stability

After any problematic upgrade:

- [ ] `sudo dpkg --configure -a`
- [ ] `sudo apt --fix-broken install`
- [ ] `sudo apt autoremove` (optional, after verifying stability)
