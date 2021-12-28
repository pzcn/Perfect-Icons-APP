cache_size=$((`du -d 0 theme_files|awk '{print $1}'`))
echo "$string_cachesize：$(printf '%.1f' `echo "scale=1;$cache_size/1024"|bc`) MB"
