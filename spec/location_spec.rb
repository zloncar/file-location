require 'location'
describe Location do
  let(:file) { "foo.feature" }
  let(:line_no)  { 12 }
  let(:location) { Location.new(file, line_no) }

  let(:other_file) { "bar.feature" }
  let(:other_line_no) { 99 }

  context 'a precise location' do
    it 'does not match a different location' do
      other = Location.new(other_file, other_line_no)

      expect( location.match?(other) ).to be_false
    end

    it 'does not match a different location in the same file' do
      other = Location.new(file, other_line_no)

      expect( location.match?(other) ).to be_false
    end

    it 'matches the same location in the same file' do
      other = Location.new(file, line_no)

      expect( location.match?(other) ).to be_true
    end

    it 'location matches wildcard location' do
      other = WildcardLocation.new( file )
      expect( location.match?(other) ).to be_true
    end
  end

  context 'a wildcard location' do
    it 'matches a precise location' do
      wildcard = WildcardLocation.new( file )
      expect( wildcard.match?( location ) ).to be_true
    end

    it 'does not match a precise location in a different file' do
      wildcard = WildcardLocation.new( file )
      location = Location.new(other_file, 10 )
      expect( wildcard.match?( location ) ).to be_false
    end

    it 'matches a ranged location in same file' do
      wildcard = WildcardLocation.new(file)
      other    = RangedLocation.new(file, 3..5)
      expect( wildcard.match?( other ) ).to be_true
    end

    it 'does not match a ranged location in a different file' do
      wildcard = WildcardLocation.new(file)
      other    = RangedLocation.new(other_file, 3..5)
      expect( wildcard.match?( other ) ).to be_false
    end

    it 'matches a wildcard location' do
      wildcard = WildcardLocation.new(file)
      other    = WildcardLocation.new(file)
      expect( wildcard.match?( other ) ).to be_true
    end

    it 'does not match a wildcard location in a different file' do
      wildcard = WildcardLocation.new(file)
      other    = WildcardLocation.new(other_file)
      expect( wildcard.match?( other ) ).to be_false
    end
  end

  context 'a ranged location' do
    it 'matches a precise location within the range in the same file' do
      ranged = RangedLocation.new(file, 10..14)
      other  = Location.new(file, 12)

      expect( ranged.match?(other) ).to be_true
    end

    it 'does not match a precise location outside the range in the same file' do
      ranged = RangedLocation.new(file, 10..14)
      other  = Location.new(file, 14.00000001)

      expect( ranged.match?(other) ).to be_false
    end

    it 'matches a wildcard location' do
      ranged   = RangedLocation.new(file, 10..14)
      wildcard = WildcardLocation.new(file)

      expect( ranged.match?(wildcard) ).to be_true
    end

    it 'does not match a wildcard location in a different file' do
      ranged   = RangedLocation.new(file, 10..14)
      wildcard = WildcardLocation.new(other_file)

      expect( ranged.match?(wildcard) ).to be_false
    end
  end

  context 'displaying as a string' do
    it 'shows "file:line_no' do
      expect( location.to_s ).to eq("foo.feature:12")
    end

    it 'shows "file' do
      wildcard = WildcardLocation.new( file )
      expect( wildcard.to_s ).to eq("foo.feature")
    end
  end
end
