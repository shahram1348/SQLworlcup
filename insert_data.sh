#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams restart identity")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS

  do 
   if [[ $YEAR != "year" ]]
   then
     # get team_id
     TEAM_ID=$($PSQL "select team_id from teams where name='$WINNER'")

     WINNER_NAME=$($PSQL "select name from teams where name='$WINNER'")
     
     # if not team_id and winner not found 
     if [[ -z $TEAM_ID ]]
       then
       #insert team
       if [[ -z $WINNER_NAME ]]
         then 
           INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
       fi

      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams winner: $WINNER
      fi
      
     fi
 
     TEAM_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    
     OPPONENT_NAME=$($PSQL "select name from teams where name='$OPPONENT'")
     
     # if not team_id and opponent not found 
     if [[ -z $TEAM_ID ]]
       then
       #insert team
       if [[ -z $OPPONENT_NAME ]]
         then 
           INSERT_TEAM_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
       fi
       
      if [[ $INSERT_TEAM_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into teams opponent: $OPPONENT
      fi
      
     fi
 
 # Make games table
 	WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'") 	
 	OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
 	INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES('$YEAR', '$ROUND', '$WINNER_ID', '$OPPONENT_ID', '$WINNER_GOALS', '$OPPONENT_GOALS')")
 	if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
      then
        echo Inserted into games, $YEAR, $/ROUND, $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENET_GOALS
      fi
   fi
 done