module TracksHelper

  def ugly_lyrics(lyrics)
    lyrics = lyrics.split("\r\n").map{ |x| x.strip }
    lyric_html = ""
    lyrics.each do |lyric|
      lyric_html << "<pre>&#9835; "
      lyric_html << h(lyric)
      lyric_html << "</pre>"
    end
    lyric_html.html_safe
  end
end
