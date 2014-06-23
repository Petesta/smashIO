$ ->
  $('.yt-preview').click -> makeVideoPlayer $(this).data('uid')

  # Initially YouTube player is not loaded
  window.ytPlayerLoaded = false

  _run = ->
    # Runs as soon as Google API is loaded
    $('.yt-preview').first().click()
    return
 
  makeVideoPlayer = (video) ->
    if !window.ytPlayerLoaded
      player_wrapper = $('#player-wrapper')
      player_wrapper.append('<div id="ytPlayer"><p>Loading player...</p></div>')
 
      window.ytplayer = new YT.Player('ytPlayer', {
        width: '50%'
        height: player_wrapper.width() / 2.777777777
        videoId: video
        playerVars: {
          wmode: 'opaque'
          autoplay: 0
          modestbranding: 1
        }
        events: {
          'onReady': -> window.ytPlayerLoaded = true
          'onError': (errorCode) -> alert("We are sorry, but the following error occured: " + errorCode)
        }
      })
    else
      window.ytplayer.loadVideoById(video)
      window.ytplayer.pauseVideo()
    return

  google.setOnLoadCallback _run

  return
