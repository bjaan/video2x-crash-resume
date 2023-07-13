# Video2X Crash Resume - Allow Video2X to resume your partially upscaled video

When your [Video2X](https://github.com/k4yt3x/video2x) upscale suddenly crashes or your PC loses power, your only choice is to start the upscale of your video from very beginning.  As the upscale of a typical full length video can take multiple days, this is a real bummer.

When you are on Windows the upscale process generates two temporary folders, that are still left intact: 1. folder that will contain all video frames as .png-files and, 2. another folder that will contain a partial set af these upscaled images.

As Video2X will also allow you to upscale a folder of images, we can use this to our advantage.  As the files names are the same in both folder, we can extract the unprocessed frames.

The plan:

1. Locate the directories with the video frames, typically and indicated in the Video2X GUI application: _C:\Users\youruser\AppData\Local\Temp\video2x_
2. This folder contains two folders, we must determine which one contains the original frames and which one does contain the partial set of upscaled video frames. As the one with the largest amount of files, you can check in the Properties dialog in File Explorer, is the orignal frames folder we need to skip every original frame that already has an upscaled counterpart, and that is what the next steps do.
3. Create a new working directory for this in a convenient location, best on the same drive then the Video2X temporary folder, e.g. _C:\Temp\UpscaleResume_
4. First move the partially upscaled folder out of the temporary Video2X directory to subfolder in the working folder - this will take a while in Windows - do not worry, e.g. _C:\Temp\UpscaleResume\Upscaled_
5. Place our Windows batchfile _video2x-copy-missing-frames.bat_ in the working folder, e.g. _C:\Temp\UpscaleResume_
6. Open a Command Prompt and change directory to the folder that , e.g. though the `cd /d C:\Temp\UpscaleResume` command
7. Execute the following command to create a new folder where your unprocessed video frames should go, to create folder called _MissingOnes_: this is `mkdir MissingOnes`
8. Run our Windows batchfile and tell it the folder 1. where the all unprocessed video frames (the other folder in the Video2X temporary directory) and 2. where all the already processed ones were (the one you moved out) and 3. where the missing ones should go, though the following command in this order: `video2x-copy-missing-frames.bat "C:\Users\youruser\AppData\Local\Temp\video2x\tmphp3ymrnx" "C:\Temp\UpscaleResume\Upscaled" "C:\Temp\UpscaleResume\MissingOnes"`
9. Once the batchfile finished, it reports `Done.`, you start your Video2X GUI again
10. Select the folder with missing ones as the only item in _Input Selection_: e.g. _C:\Temp\UpscaleResume\MissingOnes_
11. Change the output to another new folder, you create in the working folder: e.g. _C:\Temp\UpscaleResume\Resumed_
12. Set Output File Format String to _{original_file_name}{extension}_
13. Set the same driver and resolution as before, so that the new output frames match the already processed ones, of course
14. Start Video2X GUI process, and wait for to complete
14a. If Video2X would be stopped again perform step 13. below, remove the folder created in step 7. and perform steps 7. though 14. again - as to resume further
14b. If Video2X still added an underscore and _output_ to the output files in the output folder (i.e. _C:\Temp\UpscaleResume\Resumed_), you can run these commands to fix that:
```
rename extracted_??????_output.png extracted_??????.png
rename extracted_?????_output.png extracted_?????.png
rename extracted_????_output.png extracted_????.png
rename extracted_???_output.png extracted_???.png
rename extracted_??_output.png extracted_??.png
rename extracted_?_output.png extracted_?.png
```
14. Move the files from the new output, e.g. _C:\Temp\UpscaleResume\Resumed_,  in the already upscaled images, e.g. _C:\Temp\UpscaleResume\Upscaled_, so that both sets are merged
15. The final step will be to use a tool like _ffmpeg_ encode video frames in to a video file with the original audio. You want to match the framerate value of 30 with the original video's frames per second:

e.g. `ffmpeg.exe -framerate 30 -pattern_type sequence -start_number 1 -i "C:\Temp\UpscaleResume\Upscaled\extracted_%d.png" -ss 0 -i "orginal_with_audio.mkv" -vcodec libx265 -crf 15 -preset fast -map 0:v:0 -map 1:a:0 -c:a copy -shortest "C:\Temp\UpscaleResume\upscaled_with_audio.mkv"`