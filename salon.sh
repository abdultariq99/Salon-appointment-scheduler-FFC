#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  if [[ $1 ]]
  then
  echo -e "\n$1"
  fi

  echo "Welcome to Fatima's Salon. How may I help you?"
  echo -e "1) Haircut\n2) Waxing\n3) Nail Treatment"
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
  1) ADD_APPOINTMENT;;
  2) ADD_APPOINTMENT;;
  3) ADD_APPOINTMENT;;
  *) MAIN_MENU "Please enter a valid service option."
  esac
}

ADD_APPOINTMENT(){
  echo -e "\nPlease provide your phone number?"
  read CUSTOMER_PHONE

  GET_CUSTOMER_PHONE=$($PSQL "SELECT phone from customers WHERE phone = '$CUSTOMER_PHONE'")
  GET_SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ -z $GET_CUSTOMER_PHONE ]]
  then
  echo -e "\nWhat is your name?"
  read CUSTOMER_NAME
  echo -e "\nTime for appointment?"
  read SERVICE_TIME
  ADD_CUSTOMER_INFO=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  ADD_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$GET_CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")

  echo -e "\nI have put you down for a$GET_SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."

  else
  GET_CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  GET_CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone = '$CUSTOMER_PHONE'")
  echo "What should be the time of appointment,$GET_CUSTOMER_NAME"
  read SERVICE_TIME
  ADD_APPOINTMENT_INFO=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES('$GET_CUSTOMER_ID','$SERVICE_ID_SELECTED','$SERVICE_TIME')")
  echo -e "\nI have put you down for a$GET_SERVICE_NAME at $SERVICE_TIME,$GET_CUSTOMER_NAME."
  fi


}
MAIN_MENU
