#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "Welcome to My Salon, how can I help you?\n"

MAIN_MENU(){
    if [[ $1 ]]
    then
        echo -e "\n$1"
    fi

    echo -e "\n1) cut\n2) color\n3) perm\n4) style\n5) trim"
    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
        1) SERVICE_ID_SELECTED=1 AFTER_MENU ;;
        2) SERVICE_ID_SELECTED=2 AFTER_MENU ;;
        3) SERVICE_ID_SELECTED=3 AFTER_MENU ;;
        4) SERVICE_ID_SELECTED=4 AFTER_MENU ;;
        5) SERVICE_ID_SELECTED=5 AFTER_MENU ;;
        *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac
}

AFTER_MENU(){
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CHECK_CUSTOMER_PHONE=$($PSQL "SELECT phone FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CHECK_CUSTOMER_PHONE ]]
    then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER_PHONE_AND_NAME=$($PSQL "INSERT INTO customers(name, phone) VALUES ('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
    fi

    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your $SERVICE_NAME, Fabio?"
    read SERVICE_TIME
    INSERT_SERVICE_TIME=$($PSQL "INSERT INTO appointments(time, service_id, customer_id ) VALUES ('$SERVICE_TIME', $SERVICE_ID_SELECTED, $CUSTOMER_ID )")

    echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU
