function yt
  yt-dlp -o - $argv | mpv -
end
