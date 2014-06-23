class Video < ActiveRecord::Base
  attr_accessible :link

  belongs_to :user

  before_create :validate_yt_link

  VALID_YT_REGEX = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  validates :link, presence: true

  def validate_yt_link
    p "here is the #{link}"
    uid = link.match(VALID_YT_REGEX)
    p uid
    self.uid = uid[2] if uid && uid[2]

    if self.uid.length != 11
      self.errors.add(:link, 'Not a valid link')
      p "Not a valid link"
      false
    elsif Video.where(uid: self.uid).any?
      self.errors.add(:link, 'Video is not unique')
      p "Video is not unique"
      false
    else
      get_yt_video_info
    end
  end

  private

  def parse_duration(duration)
    hr  = (duration / 3600).floor
    min = ((duration - (hr * 3600)) / 60).floor
    sec = (duration - (hr * 3600) - (min * 60)).floor
   
    hr  = '0' + hr.to_s if hr.to_i < 10
    min = '0' + min.to_s if min.to_i < 10
    sec = '0' + sec.to_s if sec.to_i < 10
   
    hr.to_s + ':' + min.to_s + ':' + sec.to_s
  end

  def get_yt_video_info
    begin
      p ENV['YT_DEV']
      client = YouTubeIt::OAuth2Client.new(dev_key: ENV['YT_DEV'])
      p "the client is #{client}"
      video = client.by_video(uid)
      p video
      self.title    = video.title
      self.duration = parse_duration(video.duration)
      self.author   = video.author.name
      self.likes    = video.rating.likes
      self.dislikes = video.rating.dislikes
    rescue
      self.title = ''
      self.duration = '00:00:00'
      self.author = ''
      self.likes = 0
      self.dislikes = 0
    end
  end

end
