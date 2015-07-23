#Singleinstance force
SongkickSearch := "https://www.songkick.com/search?utf8=?&query="
SKSending := "&type=artists"
^+F12::
	FileRead,  FileContents, C:\Users\Shawn\Desktop\Artist.txt

	Loop, Parse, FileContents, `n, `r
	{
		run, %SongkickSearch%%A_LoopField%%SKSending%
	}
Return