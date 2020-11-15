# Send the header so that i3bar knows we want to use JSON:
echo '{ "version": 1 }'

# Begin the endless array.
echo '['

# We send an empty first array of blocks to make the loop simpler:
echo '[]'

# Now send blocks with information forever:
while :;
do
	DATE_FORMATTED="🗓 $(date +'%A, %d %b %G')"
	DATE_FORMATTED+=" 🕐 $(date +'%H:%M:%S')"
	echo ",[{\"name\":\"id_time\",\"full_text\":\"$DATE_FORMATTED\"}]"
	sleep 1
done
