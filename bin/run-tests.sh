FILE=test-commands

if [ ! -p test-commands ];
then
  mkfifo $FILE
else
  rm $FILE
  mkfifo $FILE
fi

while true; do
  echo 'waiting for test commands'
  sh -c "$(echo $@)"
  sh -c "$(cat test-commands)"
done

