
function java_use() {
   # unset introduced to avoid Big Sur-bug https://developer.apple.com/forums/thread/666681
   unset JAVA_HOME
   export JAVA_HOME=$(/usr/libexec/java_home -v "$1")
   export PATH=$JAVA_HOME/bin:$PATH
   java --version | head -1
}