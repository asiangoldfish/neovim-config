
## Log something to the logfile
## Syntax - Let's log `Hello world`:
##      log "Hello world"
function log() {
    printf "[%s] $1\n" "$(date +"%D %T")" >> "$LOGFILE"
}
