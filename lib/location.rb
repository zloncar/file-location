class Location
  attr_reader :file, :line_no

  def initialize(file, line_no)
    @file, @line_no = file, line_no
  end

  def match?(other)
    file == other.file && line_no == other.line_no || other.line_no == :wildcard
  end

  def to_s
    "#{file}:#{line_no}"
  end
end

class WildcardLocation
  attr_reader :file, :line_no

  def initialize( file )
    @file = file
    @line_no = :wildcard
  end

  def match?(other)
    file == other.file
  end
end
