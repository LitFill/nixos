# Nushell Utility Functions
# This file is managed by Home Manager and Conductor.

# --- Navigation Functions ---

# Create a directory and enter it.
#
# Examples:
#   mkcd new_project
export def --env mkcd [
    path: string # The path of the directory to create and enter
] {
    mkdir $path
    cd $path
}

# Go up the directory tree by one level.
#
# Examples:
#   up
export def --env up [] {
    cd ..
}

# Go back to the previous working directory.
#
# Examples:
#   back
export def --env back [] {
    cd -
}
def _list_dirs [path: path] {
    let dirs = (ls $path | where type == "dir" | sort-by name)
    if ($dirs | is-empty) {
        print $"(ansi yellow)No directories found in '(ansi green)($path)(ansi yellow)'.(ansi reset)"
    }
    $dirs
}


# Fuzzy find a directory and cd into it.
#
# Examples:
#   lcd
#   lcd /tmp
export def --env lcd [
    path: path = "." # The path to search for directories
] {
    let dirs = (_list_dirs $path)
    if ($dirs | is-empty) { return }

    let prompt = $"(ansi cyan)Select a directory in (ansi green)($path)(ansi cyan) to cd into:(ansi reset)"
    let selection = (
        $dirs | input list --fuzzy --display {
            |it| $"(ansi yellow)($it.name)(ansi reset)"
        } $prompt
    )

    if $selection != null {
        cd $selection.name
    }
}

# List directories with indices and cd into the selected number.
#
# Examples:
#   ncd
export def --env ncd [
    path: path = "." # The path to list directories from
] {
    let dirs = (_list_dirs $path)
    if ($dirs | is-empty) { return }

    $dirs | select name modified | print

    let choice = (input $"(ansi yellow)Enter the directory index: (ansi reset)")

    if ($choice | is-empty) {
        return
    }

    try {
        let idx = ($choice | into int)
        let selection = ($dirs | get $idx | get name)
        cd $selection
    } catch {
        print $"(ansi red_bold)Error:(ansi reset) Invalid index '($choice)'."
    }
}

# --- File Management Functions ---

# Smart directory listing with focus on size, mode, and name.
#
# Examples:
#   lss
#   lss /tmp
export def lss [
    path: path = "." # The path to list
] {
    ls -l $path | select name type size mode modified
}


# Show indented content of a file.
#
# Examples:
#   show README.md
export def "show ext" [
    fname: path # The file to display
] {
    let content = (
        open --raw $fname
        | lines
        | each { |line| $"($line)" }
        | str join "\n"
    )
    let ext = ($fname | path parse | get extension)
    $"```($ext) ($fname)\n($content)\n```\n"
}

def _format_file [file: path, pretty: bool, max_lines: int] {
    let lines = (open --raw $file | lines)
    let total = ($lines | length)
    let limit = if $max_lines > 0 { $max_lines } else { $total }
    let shown = ($lines | first $limit)
    let body = ($shown | each { |l| if $pretty { $"    ($l)" } else { $l } } | str join "\n")
    let trailer = if ($limit < $total) {
        if $pretty {
            $"\n    (ansi yellow)... [showing ($limit) of ($total) lines](ansi reset)"
        } else {
            "\n```\n" + $"(ansi yellow)... [showing ($limit) of ($total) lines](ansi reset)"
        }
    } else { "" }
    if $pretty {
        $"(ansi cyan)─── ($file)(ansi reset)\n\n($body)($trailer)\n"
    } else {
        let ext = ($file | path parse | get extension)
        $"```($ext) ($file)\n($body)($trailer)\n```\n"
    }
}


# Show content of all files recursively, with optional filters.
#
# Examples:
#   glimpse
#   glimpse /tmp
#   glimpse --ext nu
#   glimpse --max-lines 30
#   glimpse --hidden
#   glimpse --ext md --max-lines 10
export def glimpse [
    path: path = "."       # Root path to search (default: current dir)
    --ext: string = ""     # Filter by file extension, e.g. "nu", "md"
    --max-lines: int = 0   # Max lines shown per file (0 = unlimited)
    --hidden               # Include hidden files (those starting with '.')
    --pretty               # do not use ``` fence
] {
    let glob_flags = if $hidden {
        {no_dir: true}
    } else {
        {no_dir: true, no_symlink: false}
    }

    let pattern = ($path | path join "**/*")

    let all_files = (
        if $hidden {
            glob $pattern --no-dir
        } else {
            glob $pattern --no-dir --exclude ["**/.*", "**/.*/**"]
        }
        | if ($ext | is-not-empty) {
            where { |f|
                ($f | path parse | get extension) == $ext
            }
        } else { $in }
        | sort
    )

    if ($all_files | is-empty) {
        print $"(ansi yellow)No files found.(ansi reset)"
        return
    }

    $all_files | each { |file| _format_file $file $pretty $max_lines }
    | str join "\n"
}

# --- Data Transformation Functions ---

# Trim whitespace and remove empty lines from input.
#
# Examples:
#   "  line 1  \n\n  line 2  " | clean-lines
export def clean-lines [] {
    $in | lines | str trim | where ($it | is-not-empty)
}


# Flatten a nested record or list into a table of key-value pairs.
#
# Examples:
#   {a: {b: 1}} | to-kv
#   [1, {c: 2}] | to-kv
export def to-kv [
    prefix: string = "" # Optional prefix for keys
] {
    let input = $in
    let type = ($input | describe)

    if ($type =~ "record") {
        $input | transpose key value | each { |row|
            let new_key = if ($prefix | is-empty) { $row.key } else { $"($prefix).($row.key)" }
            $row.value | to-kv $new_key
        } | flatten
    } else if ($type =~ "list") {
        $input | enumerate | each { |item|
            let new_key = if ($prefix | is-empty) { $"($item.index)" } else { $"($prefix).($item.index)" }
            $item.item | to-kv $new_key
        } | flatten
    } else {
        [[key, value]; [$prefix, $input]]
    }
}

# --- Development Tools ---


# --- Git Status Idioms ---

# Get a structured table of git status.
#
# Examples:
#   gst
#   gst | where status == "M "
export def gst [] {
    git status --short | lines | parse --regex '^(?<status>..) (?<file>.+)'
}
