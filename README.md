# FFMPEG | Loop and Concatenate Media to a Specified Duration. 


### Inputs: 
- srcMedia *(string, 1st argument)*
- targetDuration *(number, 2nd argument)*

### Output: 
- media

### Output Format: 
- `media-T${targetDuration}.extention`

### Description:
The shell script *loopAndConcat+forDurations(-i-seconds)(ver.01).sh* loops the **srcMedia** and concatenates the loops into a single media of specified **targetDuration**.

It copies the streams of the **srcMedia** into the loops. It is, therefore, similar to using the command:
```sh
ffmpeg -stream_loop -1 -i "srcMedia" -t $targetDuration -c copy "output" 
```


### How To Run. 
Example: 
```sh
bash "loopAndConcat+forDurations(-i-seconds)(ver.01).sh" "vid.mp4" 123
```

