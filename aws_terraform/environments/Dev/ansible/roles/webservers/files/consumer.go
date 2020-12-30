package main

import (
	"bufio"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"
	"strings"

	"github.com/gorilla/mux"
	"gopkg.in/confluentinc/confluent-kafka-go.v1/kafka"
)

//User Struct to hold user info
type User struct {
	ID                string `json:"ID"`
	Name              string `json:"Name"`
	BirthYear         int    `json:"BirthYear"`
	DeathYear         int    `json:"DeathYear"`
	PrimaryProfession string `json:"PrimaryProfession"`
	KnownForTitles    string `json:"KnownForTitles"`
}

//Users slice of users
var Users []User

//SaveToStruct saves message to user struct
func SaveToStruct(msg []byte, Counter int) int {

	user := string(msg)
	scanner := bufio.NewScanner(strings.NewReader(user))

	for scanner.Scan() {
		record := scanner.Text()
		array := strings.Split(record, "\t")

		ID := array[0]
		Name := array[1]
		var BirthYear int
		if array[2] != "\\N" {
			BirthYear, _ = strconv.Atoi(array[2])
		}
		var DeathYear int
		if array[3] != "\\N" {
			DeathYear, _ = strconv.Atoi(array[3])
		}
		PrimaryProfession := array[4]
		KnownForTitles := array[5]
		singleUser := User{
			ID:                ID,
			Name:              Name,
			BirthYear:         BirthYear,
			DeathYear:         DeathYear,
			PrimaryProfession: PrimaryProfession,
			KnownForTitles:    KnownForTitles,
		}

		Users = append(Users, singleUser)
		Counter++
		fmt.Println(Counter)
	}
	return Counter
}

// //StartRouter creates server for GET endpoint
// func StartRouter() {
// 	router := mux.NewRouter()
// 	router.HandleFunc("/User/{ID}", GetUserEndpoint).Methods("GET")
// 	log.Fatal(http.ListenAndServe(":8090", router))
// 	fmt.Println("server is running")
// 	return
// }

//GetUserEndpoint handle the get request
func GetUserEndpoint(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	ID := mux.Vars(r)["ID"]
	for _, user := range Users {
		if user.ID == ID {
			json.NewEncoder(w).Encode(user)
		}
	}
}

func main() {

	fmt.Println("Start receiving from kafka")
	c, err := kafka.NewConsumer(&kafka.ConfigMap{
		"bootstrap.servers": "10.12.2.54:9092",
		"group.id":          "group-id-1",
		"auto.offset.reset": "earliest",
	})

	if err != nil {
		panic(err)
	}
	//StartRouter()

	c.SubscribeTopics([]string{"NamesTopic"}, nil)
	Counter := 0

	for {
		msg, err := c.ReadMessage(-1)
		if err == nil {

			Counter = SaveToStruct(msg.Value, Counter)

		} else {
			fmt.Println("consumer error", err)
			break
		}
	}
	c.Close()

	router := mux.NewRouter()
	router.HandleFunc("/User/{ID}", GetUserEndpoint).Methods("GET")
	log.Fatal(http.ListenAndServe(":8090", router))
	fmt.Println("server is running")

}
