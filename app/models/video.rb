class Video < ActiveRecord::Base
  attr_accessible :link

  belongs_to :user

  before_create :validate_yt_link

  validates :link, presence: true

  VALID_YT_REGEX = /^.*(youtu.be\/|v\/|u\/\w\/|embed\/|watch\?v=|\&v=)([^#\&\?]*).*/i

  # 1. N64
  # 2. Melee
  # 3. Brawl
  # 4. N64 and Melee
  # 5. N64 and Brawl
  # 6. Melee and Brawl
  # 7. N64, Melee, and Brawl

  CHARACTERS = { pikachu: 7, kirby: 7, fox: 7, :"captain falcon" => 7, mario: 7,
                 yoshi: 7, dk: 7, jigglypuff: 7, ness: 7, link: 7, luigi: 7, samus: 7,
                 falco: 6, sheik: 6, zelda: 6, peach: 6, :"mr. game & watch" => 6,
                 marth: 6, :"ice climbers" => 6, ganondorf: 6, bowser: 6, :"dr. mario" => 2,
                 mewtwo: 2, pichu: 2, roy: 2, :"young link" => 2, ike: 3, ivysaur: 3,
                 lucario: 3, lucas: 3, metaknight: 3, olimar: 3, pit: 3,
                 :"pokemon trainer" => 3, rob: 3, snake: 3, sonic: 3, squirtle: 3,
                 :"toon link" => 3, wario: 3, wolf: 3, :"zero suit samus" => 3
               }

  LEVELS = [ "dream land", "kongo jungle", "yoshi's island", "mushroom kingdom",
             "planet zebes", "saffron city", "hyrule castle", "peach's castle",
             "sector z", "brinstar", "corneria", "fountain of dreams", "great bay",
             "green greens", "ice mountain", "jungle japes", "mushroom kingdom",
             "mute city", "onett", "princess peach's castle", "pokemon stadium",
             "rainbow cruise", "temple", "venom", "yoshi's story", "battlefield",
             "big blue", "brinstar depths", "final destination", "flat zone",
             "fourside", "mushroom kingdom ii", "poke floats", "delfino plaza",
             "mushroomy kingdom", "mario circuit", "rumble falls", "bridge of eldin",
             "norfair", "frigate orpheon", "halberd", "lylat cruise", "pokemon stadium 2",
             "port town aero drive", "castle siege", "warioware inc.", "distant planet",
             "smashville", "new pork city", "summit", "skyworld", "pictochat",
             "shadow moses island"
           ]

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

  def trim!(string)
    string.tr!('().&-', '')
  end

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
