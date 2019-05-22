class Song < ActiveRecord::Base
  belongs_to :artist
  belongs_to :genre
  has_many :notes

  accepts_nested_attributes_for :artist
  accepts_nested_attributes_for :notes, reject_if: :note_content_missing

  def note_content_missing(note_attributes)
    note_attributes['content'].blank?
  end

  def note_contents
    # notes.pluck(:content) <-- this would work if we assume the song is in the DB (which the tests don't)
    self.notes.map { |note| note.content }
  end

  def note_contents=(content_list)
    content_list.each do |content|
      if !content.blank?
        self.notes.build(content: content)
      end
    end
  end

  def genre_name
    self.genre.name
  end

  def genre_name=(name)
    self.genre = Genre.find_or_create_by(name: name)
  end

  def artist_name
    self.artist.name
  end

  def artist_name=(name)
    self.artist = Artist.find_or_create_by(name: name)
  end
end
