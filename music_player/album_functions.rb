require './input_functions'
require 'gosu'
require 'rubygems'
# It is suggested that you put together code from your 
# previous tasks to start this. eg:
# TT3.2 Simple Menu Task
# TT5.1 Music Records
# TT5.2 Track File Handling
# TT6.1 Album file handling

# Task 6.1 T - use the code from last week's tasks to complete this:
# eg: 5.1T, 5.2T

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class Album
# NB: you will need to add tracks to the following and the initialize()
	attr_accessor :title, :artist, :genre, :tracks 

# complete the missing code:
	def initialize ()
		# insert lines here
		@title = "something"
        @artist = "someone"
        @genre = Genre::POP
		@tracks = Array.new()
    end
end

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

def playTrack(track_id, album)
    # complete the missing code    
  @song = Gosu::Song.new(album.tracks[track_id].location)
    @song.play
    @song.volume = 0.5
    return @song
  # Uncomment the following and indent correctly:
    #	end
    # end
end

# Reads in and returns a single track from the given file

def read_track(music_file)
	# fill in the missing code
	name = music_file.gets()
  location = music_file.gets()
  track= Track.new(name,location)
end

# Returns an array of tracks read from the given file

def read_tracks(music_file, count)
	tracks = Array.new()
	i=0
  # Put a while loop here which increments an index to read the tracks
  	while i < count
      track = read_track(music_file)
      tracks << track
      i +=1
    end 
	  return tracks
    
end

# Takes a single track and prints it to the terminal
def print_track(track,i)
	puts(i.to_s.chomp + " - " + track.name)
  puts(track.location)
end

# Takes an array of tracks and prints them to the terminal
def print_tracks(tracks)
	# print all the tracks use: tracks[x] to access each track.
	x = 0
  length = tracks.length
  puts("Track List: ")
  while x < length
    print_track(tracks[x],x+1)
    x += 1
  end  
end

# Reads in and returns a single album from the given file, with all its tracks

def read_album(music_file)

  # read in all the Album's fields/attributes including all the tracks
  # complete the missing code
	album = Album.new()
	album_artist = music_file.gets() 
	album_title = music_file.gets()
	album_genre = music_file.gets.to_i()
	track_count = music_file.gets.to_i()
	if track_count <= 15 then
	  tracks = read_tracks(music_file,track_count)
	  album = Album.new()
	  album.title = album_title
	  album.artist = album_artist
	  album.genre = album_genre
	  album.tracks = tracks
	  return album
	else
		puts("Please reselect a file with albums which have less than 15 tracks each.")		
	end
end

def read_in_albums()
	albums = Array.new
	begin
	  file_name = read_string("Enter the text file to load: ")
	  music_file = File.new(file_name, "r")
    rescue Errno::ENOENT => e
	end

	i = 0
	if music_file.nil? then
		puts("File does not exist. Please enter again")
		file_has_loaded = -1
	else
	  album_count = music_file.gets().to_i
	  while i < album_count do 
	  albums << read_album(music_file)
	  i += 1
	  end
	  file_has_loaded = 1
	  return albums,file_has_loaded
	  music_file.close()
	end
end

# Takes a single album and prints it to the terminal
def print_album(album,id)

  # print out all the albums fields/attributes except tracks
  	puts("ALBUM ID: " + id.to_s.chomp)
    puts(album.title + " by " + album.artist)
	puts('Genre is ' + $genre_names[album.genre] )
	
end
def print_albums(albums)
	option = read_integer_in_range("1 - Display all \n2 - Display genre",1,2)
	if option == 1 then
	  i = 0
	  while i < albums.length do
		print_album(albums[i],i+1)
		i += 1
	  end
	elsif option == 2 then
		genre = read_integer_in_range("Select Genre \n1 - Pop\n2 - Classic\n3 - Jazz\n4 - Rock ",1,4)
		i = 0
		while i < albums.length do
			if albums[i].genre == genre then 
				print_album(albums[i],i+1)
			end 
			i += 1
		end
	end

end
def play_track(album)
	length = album.tracks.length
	i = read_integer_in_range("enter track number: ",1,length)
	puts("Playing track " + album.tracks[i-1].name.chomp + " from album " + album.title.chomp)
	return i-1
end

# Reads in an album from a file and then print the album to the terminal
def search_for_track_name(tracks, search_name)
    i = 0
    flag = false
	until i == tracks.length do 
      i += 1
      track_name = tracks[i-1].name.chomp
	  if (search_name ==  track_name)
        flag = true
        index = i-1
	  end
	end
	if flag == true 
	puts("Found " + search_name)
	puts(" at " + index.to_s)
	else
	print(-1)
	end
end
def play_album(albums)
	length = albums.length
	album_index = read_integer_in_range("Enter album ID:",1,length) - 1
	album = albums[album_index]
	print_tracks(album.tracks)
    track_id = play_track(album)
    return album_index,track_id, album
end
def update_album_title(album)
	new_title = read_string("Enter new title: ")
	album.title = new_title
	return album.title
end
def update_album_genre(album)
	new_genre = read_integer_in_range("Enter new genre between 1 - 4",1,4)
	album.genre = new_genre
	return album.genre 
end	
def update_album(albums)
	length = albums.length
	index = read_integer_in_range("Album ID: ",1, length)
	album = albums[index-1]
	option = 0
	puts("Maintain Albums Menu:")
    puts("1 To Update Album Title\n")
    puts("2 To Update Album Genre\n")
    puts("Press Enter to to return to main menu\n")
	option = read_string("Please enter your choice:")
	if option == "1" then
      album.title = update_album_title(album)
	elsif option == "2"
      album.genre = update_album_genre(album)
	elsif option.empty?
		finished = true
	else 
		puts("Invalid Entry")
	end
  print_album(album,index)
  return albums
end

def main()
	option =0
  finished = false
  file_has_loaded = -1
  while finished == false
    puts("1 Read in Albums\n")
    puts("2 Display Albums\n")
	puts("3 Select an Album to play\n")
	puts("4 Update an existing Album")
    puts("5 Exit the application\n")
    option = read_integer_in_range("Please enter your choice:", 1, 5)
	if option == 1 then
		albums,file_has_loaded = read_in_albums()
	elsif option == 5 then 
		finished = true
	end
	if (option > 1 && option < 5) && file_has_loaded != 1 then
	  puts("File does not exist!")
	  finished = true
	else
	  case option
        when 2
          print_albums(albums)
        when 3
          track_id, album = play_album(albums)
        when 4
	      albums = update_album(albums)
	  end	
    
    end
	
	#search_name = read_string("Enter the track name you wish to find: ")
	#search_for_track_name(album.tracks, search_name)
  end
end



