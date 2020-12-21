package main

import (
	"fmt"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/awserr"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/aws/aws-sdk-go/service/s3"
)

const (
	//Region
	REGION = "us-east-1"
)

func listS3Buckets(sess *session.Session) string {

	// Create S3 service client
	svc := s3.New(sess)

	result, err := svc.ListBuckets(&s3.ListBucketsInput{})
	if err != nil {
		fmt.Println("Failed to list buckets")
	} else {
		fmt.Println(result)
	}
	return result.GoString()

}

func createS3Bucket(sess *session.Session) string {

	svc := s3.New(sess)
	resp, err := svc.CreateBucket(&s3.CreateBucketInput{
		ACL:    aws.String(s3.BucketCannedACLPublicRead),
		Bucket: aws.String("my-test-bucket63434873464378"),
		// CreateBucketConfiguration: &s3.CreateBucketConfiguration{
		// 	LocationConstraint: aws.String("us-east-1"),
		// },
	})
	if err != nil {
		if aerr, ok := err.(awserr.Error); ok {
			switch aerr.Code() {
			case s3.ErrCodeBucketAlreadyExists:
				fmt.Println("Bucket name already in use!")
				panic(err)
			case s3.ErrCodeBucketAlreadyOwnedByYou:
				fmt.Println("Bucket exists and is owned by you!")
			default:
				panic(err)
			}
		}
	}

	return resp.GoString()
}

func main() {
	// Initialize a session to  load credentials from the shared credentials file ~/.aws/credentials.
	sess, err := session.NewSession(&aws.Config{
		Region: aws.String("us-east-1")},
	)
	if err != nil {
		fmt.Println("failed to load credentials")
	}

	listS3Buckets(sess)
	//createS3Bucket(sess)

}
