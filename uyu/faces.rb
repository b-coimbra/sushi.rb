# typed: true
# frozen_string_literal: true

class Faces
  attr_reader :faces

  def initialize
    @path = './faces'
    @faces = []

    set_faces if Dir.exists?
  end

  def set_faces
    Dir[@path + '/*'].each do |face|
      @faces << face
    end
  end
end
