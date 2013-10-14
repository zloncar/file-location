class Location
  attr_reader :file, :line_no

  def initialize(file, line_no)
    @file, @line_no = file, line_no
  end

  def match?(other)
    puts "In Location #{other}"
    file == other.file && ( line_no == other.line_no || other.line_no == :wildcard )
  end

  def to_s
    "#{file}:#{line_no}"
  end
end

class WildcardLocation
  attr_reader :file

  def initialize( file )
    @file = file
  end

  def line_no
    :wildcard
  end

  def match?(other)
    puts "In WildcardLocation #{other}"
    file == other.file
  end

  def to_s
    "#{file}"
  end

end

class RangedLocation
  attr_reader :file, :line_range

  def initialize( file, line_range )
    @file = file
    @line_range = line_range
  end

  def match?(other)
    puts "In RangedLocation #{other}"
    file == other.file && ( line_range.member?(other.line_no) || other.line_no == :wildcard )
  end
end
