# About
The [Photos](https://www.apple.com/macos/photos/) app on MacOS shows the accurate date of videos.  However when you export those videos, even using "Export Unmodified Originals", Finder frequently shows the wrong date.  That is because the date you actually want is buried somewhere in the [EXIF data](https://en.wikipedia.org/wiki/Exif) of the image, separate from the created / modified / accessed timestamps that all unix files have.

To get at the date you want, you can use the excellent [ExifTool](https://sno.phy.queensu.ca/~phil/exiftool/) tool from Phil Harvey.

The below example shows the exif output of a video from the [Kidizoom camera from vtech](https://www.vtechkids.com/product/detail/17125/Kidizoom_Camera_Pix_Pink).

```
$ exiftool 100_0069.AVI
ExifTool Version Number         : 11.25
File Name                       : 100_0069.AVI
Directory                       : .
File Size                       : 3.2 MB
File Modification Date/Time     : 2018:01:01 23:01:11-06:00
File Access Date/Time           : 2019:01:21 08:22:29-06:00
File Inode Change Date/Time     : 2019:01:21 08:21:21-06:00
File Permissions                : rwxr-xr-x
File Type                       : AVI
File Type Extension             : avi
MIME Type                       : video/x-msvideo
Frame Rate                      : 15
Max Data Rate                   : 0 kB/s
Frame Count                     : 622
Stream Count                    : 2
Stream Type                     : Video
Video Codec                     : mjpg
Video Frame Rate                : 15
Video Frame Count               : 622
Quality                         : 0
Sample Size                     : Variable
BMP Version                     : Windows V3
Image Width                     : 160
Image Height                    : 120
Planes                          : 0
Bit Depth                       : 24
Compression                     : MJPG
Image Length                    : 57600
Pixels Per Meter X              : 0
Pixels Per Meter Y              : 0
Num Colors                      : Use BitDepth
Num Important Colors            : All
Audio Codec                     : .
Audio Sample Rate               : 22050
Audio Sample Count              : 906240
Encoding                        : Microsoft PCM
Num Channels                    : 1
Sample Rate                     : 22050
Avg Bytes Per Sec               : 44100
Bits Per Sample                 : 16
Date Created                    : 2016:12:24`
Duration                        : 0:00:41
Image Size                      : 160x120
Megapixels                      : 0.019
```

Note that the date I actually want here is in the `Date Created` field, which is entirely different from the `File Modification Date`, `File Access Date`, or `File Inode Change Date` fields.

ExifTool has good handling for dates (see [-dateFormat](https://sno.phy.queensu.ca/~phil/exiftool/exiftool_pod.html)).  Unfortunately the date from this camera isn't formatted in a compatible way, so we can use `awk` to pull out the parts we want.

```
$ DATE=`exiftool -DateCreated -b 100_0069.AVI`
$ echo $DATE
2016:12:24`
$ echo $DATE | awk -F ':' '{print $1}'
2016
$DATE | awk -F ':' '{print $2}'
12
$ echo $DATE | awk -F ':' '{print $3}'
24
```
