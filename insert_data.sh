#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi
# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games, teams")
while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ ! $YEAR == "year" ]]
  then
    for TEAM in "$WINNER" "$OPPONENT"
    do
      CURRENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM'")

      if [[ -z $CURRENT_ID ]]
      then
        echo $($PSQL "INSERT INTO teams(name) VALUES('$TEAM')")
        CURRENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM'")
      fi

      if [[ $TEAM == $WINNER ]]
      then
        WINNER_ID=$CURRENT_ID
      else
        OPPONENT_ID=$CURRENT_ID
      fi
    done

    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
    VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
  fi
done < games.csv