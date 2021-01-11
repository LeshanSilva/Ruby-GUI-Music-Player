require 'rubygems'
require 'gosu'
require './input_functions.rb'
require './album_functions.rb'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
TrackLeftX = 120
Ypos = 525
module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
    attr_accessor :bmp

    def initialize (file)
        @bmp = Gosu::Image.new(file)
         
    end
    
end

class MusicPlayerMain < Gosu::Window
    

    def initialize
	    super(600,800,false)
        self.caption = "Music Player"
        @background = BOTTOM_COLOR
        @player = TOP_COLOR
        @track_font = Gosu::Font.new(20) 
        @file_has_loaded = 0
        @albums = Array.new
        #this while loop is to avoid reloading a file
        while @file_has_loaded != 1 do
          @albums,@file_has_loaded = read_in_albums()
        end
           print_albums(@albums)
          @album = Album.new()
          i = 0
          @tracks = Array.new
          @album_id, @current_song, @album = play_album(@albums)
          while i < @albums.length do
            @tracks << @albums[i].tracks
            i += 1
          end
          @location = @album.tracks[@current_song].location.chomp
          @song = Gosu::Song.new(@location) 
          @song.play(false)
          @song.volume = 0.5
                 
    end 
        
  # Draws the artwork on the screen for all the albums

  def draw_albums()
    # complete this code
    @album_image = ArtWork.new("images/NeilDiamondHits.bmp")
    case @album_id
    when 0
      @album_image = ArtWork.new("images/NeilDiamondHits.bmp")
    when 1
      @album_image = ArtWork.new("images/BrunoMarsDooWops.bmp")
    when 2
      @album_image = ArtWork.new("images/MohombiMovemeant.bmp")
    when 3
      @album_image = ArtWork.new("images/AkonFreedom.bmp")
    end
    @album_image.bmp.draw(180,260,2)
  end
  #Draws the tools on gui
  def draw_buttons()
    @music_buttons = ArtWork.new("media/play_buttons.bmp")
    @music_buttons.bmp.draw(45,550,3)
  end
  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false
  # an improvement would be to avoid hardcoding the coordinates below

  def area_clicked(mouse_x,mouse_y)
     # complete this code
     if (mouse_y < 642 && mouse_y> 545) then
       if (mouse_x < 548 && mouse_x > 454) then
          return 5
       elsif (mouse_x <445 && mouse_x > 353) then
          return 4
       elsif (mouse_x < 342 && mouse_x > 250) then
          return 3
       elsif (mouse_x < 241 && mouse_x > 148) then
          return 2
       elsif (mouse_x < 138 && mouse_x > 42) then
          return 1
       end
     end
  end

  def display_track(title)
  	@track_font.draw_text(title.chomp, TrackLeftX, Ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK, mode=:default)
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR
	def draw_background
        Gosu.draw_rect(0, 0, 600, 800, @background, ZOrder::BACKGROUND, mode=:default)
        Gosu.draw_rect(40, 40, 510, 710, @player, ZOrder::PLAYER, mode=:default)
        display_track(@album.tracks[@current_song].name.chomp+ " from album " + @album.title)
        draw_albums()
        draw_buttons()
        
	end

 # Draws the album images and the track list for the selected album
	def draw
		draw_background()
	end

  def needs_cursor?; true; end

	def button_down(id)
        
        case id
        when Gosu::KbS
            @song.stop
        when Gosu::KbP
            @song.play
        when Gosu::KbDown
            if @song.volume > 0.05 then
                @song.volume -= 0.1
            end
        when Gosu::KbUp
            if @song.volume < 0.95 then 
                @song.volume += 0.1
            end
        when Gosu::KbRight
          if @current_song < @album.tracks.length-1 then
            @current_song += 1
            @location = @album.tracks[@current_song].location.chomp
            @song = Gosu::Song.new(@location) 
            @song.play
                 
          else 
            puts("This was the last album track")
            if @album_id < @albums.length-1 then   
              @album_id += 1
            else
              @album_id = 0
            end
            @current_song = 0
            @album = @albums[@album_id]
            @location = @album.tracks[@current_song].location.chomp
            @song = Gosu::Song.new(@location) 
            @song.play
          end
        when Gosu::KbLeft
            if @current_song > 0 then
              @current_song -= 1
              @location = @album.tracks[@current_song].location.chomp
              @song = Gosu::Song.new(@location)   
              @song.play 
                
            else 
              puts("This was the first album track")
              if @album_id > 0 then
                @album_id -= 1
              else
                @album_id = @albums.length-1
              end
              puts(@album_id.to_s)
              @album = @albums[@album_id]
              @current_song = @album.tracks.length-1
              @location = @album.tracks[@current_song].location.chomp
              @song = Gosu::Song.new(@location) 
              @song.play
            end
            #calling area_clicked for detecting a click on a button
        when Gosu::MsLeft
            button = area_clicked(mouse_x,mouse_y)
            case button
            when 1
              @song.pause
            when 2
              @song.stop
            when 3
              @song.play(true)
            when 4
                if @current_song < @album.tracks.length-1 then
                    @current_song += 1
                    @location = @album.tracks[@current_song].location.chomp
                    @song = Gosu::Song.new(@location) 
                    @song.play
                else 
                    puts("This was the last album track")
                    if @album_id < @albums.length-1 then   
                      @album_id += 1
                    else
                      @album_id = 0
                    end
                    @current_song = 0
                    @album = @albums[@album_id]
                    @location = @album.tracks[@current_song].location.chomp
                    @song = Gosu::Song.new(@location) 
                    @song.play
                end
            when 5
                if @current_song > 0 then
                    @current_song -= 1
                    @location = @album.tracks[@current_song].location.chomp
                    @song = Gosu::Song.new(@location)   
                    @song.play 
                      
                else 
                    puts("This was the first album track")
                  if @album_id > 0 then
                    @album_id -= 1
                  else
                    @album_id = 3
                  end
                    @album = @albums[@album_id]
                    @current_song = @album.tracks.length-1
                    @location = @album.tracks[@current_song].location.chomp
                    @song = Gosu::Song.new(@location) 
                    @song.play
                    
                end      
            end
        end
    
  end
              
end  

# Show is a method that loops through update and draw

MusicPlayerMain.new.show
