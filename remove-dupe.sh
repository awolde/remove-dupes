IFS=$'\n'; 
deleted=0
totalsize=0
#fdupes . -r > dupes
for ((x=1 ; x<$(wc -l dupes | awk '{print $1}'); x++)) 
do 
#	echo "current line #$x ..."
	path=$(more +${x} dupes | head -1); 
	if [ -z $path ]; 
	then 
		echo "==="; 
	else 
		file=$(basename  $path); 
		size=$(du -k $path | awk '{ print $1 }') 
		echo "Keep $path"
		for ((i = $((x+1)) ; ; i++))
		do
			#echo $i
			nextpath=$(more +${i} dupes | head -1);
			if [ -z $nextpath ]; then
#				echo "jumping to next file...on line #$i."
				x=$i
				break
			else
				nextsize=$(du -k $nextpath | awk '{ print $1 }')
				if [ $nextsize == $size ]; then
					echo "Delete $nextpath"
					#rm -rf "$nextpath"
					#ln -s "$path" "$nextpath"
					((deleted++))
					totalsize=$((totalsize+nextsize))
				fi
			fi
		done
	     		
	fi; 
done
echo "$deleted files deleted!!~~"
echo "$totalsize space saved"
