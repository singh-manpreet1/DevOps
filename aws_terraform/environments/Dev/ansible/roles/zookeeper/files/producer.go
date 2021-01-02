package main

import (
	"bufio"
	"bytes"
	"fmt"
	"log"
	"os"
	"time"

	"github.com/Shopify/sarama"
)

var brokers = []string{"10.12.2.54:9092"}

func main() {

	File, err := os.Open("data.tsv")

	if err != nil {
		log.Panic(err)
	}
	defer File.Close()

	config := sarama.NewConfig()
	config.Producer.RequiredAcks = sarama.WaitForAll
	config.Producer.Retry.Max = 5
	config.Producer.Return.Successes = true
	sarama.Logger = log.New(os.Stdout, "[sarama] ", log.LstdFlags)

	brokers := []string{"10.12.2.54:9092"}
	producer, err := sarama.NewSyncProducer(brokers, config)

	if err != nil {
		panic(err)
	}

	defer func() {
		err := producer.Close()
		if err != nil {
			panic(err)
		}
	}()

	topic := "NamesTopic"
	start := time.Now()

	scanner := bufio.NewScanner(File)

	buf := bytes.NewBuffer(make([]byte, 0, 500*1024))
	counter := 0

	for scanner.Scan() {
		record := scanner.Text() + "\n"
		recordByte := []byte(record)
		lineLength := len(recordByte)

		if lineLength+buf.Len() > buf.Cap() {
			msg := &sarama.ProducerMessage{
				Topic: topic,
				Value: sarama.ByteEncoder(buf.Bytes()),
			}
			_, _, err = producer.SendMessage(msg)
			if err != nil {
				panic(err)
			}

			buf.Reset()
		}

		buf.Write(recordByte)
		fmt.Println("sent another chunk of data")
		//counter++
		//fmt.Println("Size of buffer", buf.Len())
	}

	elapsed := time.Since(start)
	fmt.Println(counter)
	log.Printf("Binomial took %s", elapsed)

}
