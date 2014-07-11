class Video < ActiveRecord::Base
  attr_accessible :link

  belongs_to :user

  before_create :validate_yt_link

  VALID_YT_REGEX = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  validates :link, presence: true

  def filter_videos(video)
    self.videos.select { || }
  end

  def validate_yt_link
    uid = link.match(VALID_YT_REGEX)
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

  def get_yt_metadata(video)
    if video.keywords.empty?
      self.keywords = ''
    else
      self.keywords = video.keywords.join(" ")
    end

    self.title    = video.title
    self.author   = video.author.name
    self.term     = video.categories[0].term
    self.label    = video.categories[0].label
    self.likes    = video.rating.likes
    self.dislikes = video.rating.dislikes
    self.duration = parse_duration(video.duration)
  end

  def set_yt_default_info
    self.title    = ''
    self.author   = ''
    self.term     = ''
    self.label    = ''
    self.keywords = ''
    self.likes    = 0
    self.dislikes = 0
    self.duration = '00:00:00'
  end

  def get_yt_video_info
    begin
      client = YouTubeIt::OAuth2Client.new(dev_key: ENV['YT_DEV'])
      video = client.video_by(uid)
      get_yt_metadata(video)
    rescue
      set_yt_default_info
    end
  end

end
