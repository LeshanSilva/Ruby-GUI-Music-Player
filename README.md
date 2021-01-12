# Ruby-GUI-Music-Player
This is a GUI music player created using ruby and its library Gosu. There may be better ways of doing this or room for improvement but this is what i came up with.
For further details check the video on my youtube channel Leshan Silva.

Instructions:
1) load the songs you want to play into the sounds file. It can be .mp3, .ogg or .wav
2) Update the album.txt file in the following format;
    "Total number of albums(as a number)"
    "Artist name"
    "Album Name"
    "genre number(check line 14, you can add or delete any genre. eg: 4 would be Rock"
    "Number of Tracks"
    "Track title"
    "File location(if all is in the same folder(sounds) its easier"
    "Once all tracks and their locations for that album are mentioned, we repeat for the next album. Artist name, Album name, genre etc."
3) Run gui_music_player.rb, when asked to load file, enter album.txt, and follow the menu
    
* If you want to add your own album pictures,
    i) add the album cover pictures for all albums to the images folder. (.png 225x225 is preferred) 
    ii) lines 61 to 70 in gui_music_player.rb: Change the file locations for the newly added images    
    
Music Player Controls
1) Up & Down arrow keys for volume. (make sure you click on the window first)
2) press S to stop, P to play
3) you can click on the buttons in the interface

Enjoy! :)
