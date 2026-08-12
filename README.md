# DOPM

DOPM is the deterministic package acquisition and lock tool for Dolet projects.
It is written in Dolet and keeps every project's dependencies isolated from the
compiler installation.

## Responsibilities

- DOPM downloads packages into `.dopm/packages`.
- `dopm.lock` records the exact Git commit used by each package.
- Obin reads a project's manifest, asks DOPM to synchronize dependencies, then
  invokes `doletc` with the project-local package root.
- `doletc` compiles sources and links native package libraries. It does not
  download packages or interpret an application manifest.

Git is an explicit acquisition boundary. DOPM itself uses Dolet's portable
platform APIs for files, directories, environment variables, and process
management.

Package names use the portable lowercase form `[a-z0-9_-]+`; this avoids a
lock resolving to two different directory identities on case-sensitive and
case-insensitive filesystems.

## Commands

```text
dopm install <name> [source-or-revision]
dopm remove <name>
dopm list
dopm search
dopm --version
```

`source-or-revision` may be a Git URL, a local repository path, a branch, tag,
or commit. Spell relative local paths with `./` or `../` (an already-existing
path is also recognized); this keeps branch names such as `feature/rendering`
unambiguous. The installed commit--not a floating branch name--is stored in the
lock file. A pre-existing package directory is accepted only after its Git
revision matches the lock/request and its complete tracked/untracked tree is
clean. Stale or edited directories are replaced.

Install/remove operations take a per-project interprocess lock. An update is
cloned and checked out in a temporary directory, the old package is preserved
as a rollback slot, and publication plus `dopm.lock` replacement are atomic.
An interrupted transaction is recovered on the next invocation.

The optional `packages.txt` registry uses this line format:

```text
name|canonical-git-source|default-revision
```

## Building

Set `DOLETC` to a compiler path or put `doletc` on `PATH`, then run:

```powershell
.\windows_build.bat
```

or:

```sh
./linux_build.sh
```

The outputs are `build/dopm.exe` on Windows and `build/dopm` on Linux.

## Project layout

```text
project/
  dolet.toml
  dopm.lock
  .dopm/
    packages/
      package-name/
```

Generated package directories and build outputs must not be committed. Commit
`dopm.lock` so another machine resolves the same source revisions.

## Platform model

Windows uses the Win32 platform pack. Linux core operations use direct syscalls;
desktop packages may separately require the native X11/Vulkan system ABI. That
desktop boundary belongs to those packages/platform resources, not DOPM's
package-resolution logic.
