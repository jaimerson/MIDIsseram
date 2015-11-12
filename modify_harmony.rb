require 'rubygems'
require 'bundler/setup'

require 'midilib'
require 'midilib/io/seqreader'
require 'midilib/io/seqwriter'

# Create a new, empty sequence.
seq = MIDI::Sequence.new()

# Read the contents of a MIDI file into the sequence.
File.open('./examples/NoFences.mid', 'rb') do |file|
  seq.read(file) do |track, num_tracks, i|
    # Print something when each track is read.
    puts "read track #{i} of #{num_tracks}"
  end
end

octaves = ((ARGV[0] && !ARGV[0].empty? && ARGV[0].to_i) || 1)
notes = octaves * 12
channel = ((ARGV[1] && !ARGV[1].empty? && ARGV[1].to_i) || 0)

# Iterate over every event in every track.
seq.each do |track|
  track.each do |event|
    # If the event is a note event (note on, note off, or poly
    # pressure) and it is on MIDI channel 5 (channels start at
    # 0, so we use 4), then transpose the event down one octave.
    if MIDI::NoteEvent === event && event.channel == channel
      event.note = (event.note + notes) % 128
    end
  end
end

# Write the sequence to a MIDI file.
File.open('./output/altered.mid', 'wb') { | file | seq.write(file) }
%x{timidity output/altered.mid -Ow -o - | lame - -b 64 converted/altered.mp3}