Check potential leaked or hardcoded secrets in the staged files, if the workdir is clean, check the last commit changed files

The following items are considered non-sensitive information
- private IPs
- public hostname
- internal hostname (lab-local)
- cloudflare public IPv4

After all check is done, write a summary report, and a conclusion with format:
<count> secrets found.
